Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3EE15AD
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 01:16:30 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-52f2445e802so78329587b3.10
        for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 17:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wrq62AzkctYtWs8cF7vErW/C4PklOl8HkpwRKHnxMak=;
        b=BdgtTh4wvUuTb8JeaMBxrKlOym4Z2lbO6UkdORicuqaxW2ytXMz2XcnqvpbumjhCxw
         kNGDepdGdtEoKLdw092AFODNvzCMlyiwvhlPXCwaEKYSDGskA7i+iQJxFRJI2f3L4D2Q
         0fBbbK7SiQDlThYAgELeEisHdzK20Et9ma72dMjy9U7/v/A48sbk8Qp2jQiab+E93DAj
         xN1xfDJPvE2BwbthpaJi/PHt0UI5lu9eZT+3KcMPAA4TQ+k+RvHZsaD/rhKgodiqb7Ru
         4U9xdyJ8pjL1IqQoUeUTBY0RNJouN0cCVbL8GjN2mmBFtLyIl4uj63EaeUwuYfNgOi47
         wQqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wrq62AzkctYtWs8cF7vErW/C4PklOl8HkpwRKHnxMak=;
        b=4pnS0QvivVOGJ2ul4+qghiQuZTZNuunCfmlsl2FgovNhB5H6eGrDSYMA5/1GSU516k
         2tTtSYSg0FbegS19AW8bsbI/KEyP0AOLZLmQrVV5r3V4R6BM98CU2mCX/O4IpzZQ+zhd
         ZYbl96wYMe9RTijezCi0EexKYxCDBL9R4esx6v9idi2EAp1gqy0BUadvLUA0SGQjCZc7
         4RORadgFS2IH2oY/srwdnQIhGN8SlrklkvFbmqqSFS2gPK6OfKWNiS4WXwOqJ5mPs7vu
         CZ5ZgQiM0zBWdFwzNsO4xYMQaogrBCxBGnu4X5/reEYx8y97RFhuQ3z9OQRQNi71tRrn
         ku/g==
X-Gm-Message-State: AO0yUKWwsaPtqUo9xkgeXUG3+qRzmCQdN5QamhnsgIw8Cjo49bdBYUGM
	BbNY2DS3rft+hKrFmBopKsgpBLIQ7Zx3Aw==
X-Google-Smtp-Source: AK7set/R/GsUX/jau7ramnhMxdFq70R7jXaandJ76F1bsa5NTsCH8j78V1e7saDdWz2v2aIDjSthZkizR2msGA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:80c4:0:b0:52e:cda8:1195 with SMTP id
 q187-20020a8180c4000000b0052ecda81195mr68928ywf.329.1676423789447; Tue, 14
 Feb 2023 17:16:29 -0800 (PST)
Date: Wed, 15 Feb 2023 01:16:06 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215011614.725983-1-amoorthy@google.com>
Subject: [PATCH 0/8] Add memory fault exits to avoid slow GUP
From: Anish Moorthy <amoorthy@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>, Anish Moorthy <amoorthy@google.com>, 
	Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This series improves scalabiity with userfaultfd-based postcopy live
migration. It implements the no-slow-gup approach which James Houghton
described in his earlier RFC ([1]). The new cap
KVM_CAP_MEM_FAULT_NOWAIT, is introduced, which causes KVM to exit to
userspace if fast get_user_pages (GUP) fails while resolving a page
fault. The motivation is to allow (most) EPT violations to be resolved
without going through userfaultfd, which involves serializing faults on
internal locks: see [1] for more details.

After receiving the new exit, userspace can check if it has previously
UFFDIO_COPY/CONTINUEd the faulting address- if not, then it knows that
fast GUP could not possibly have succeeded, and so the fault has to be
resolved via UFFDIO_COPY/CONTINUE. In these cases a UFFDIO_WAKE is
unnecessary, as the vCPU thread hasn't been put to sleep waiting on the
uffd.

If userspace *has* already COPY/CONTINUEd the address, then it must take
some other action to make fast GUP succeed: such as swapping in the
page (for instance, via MADV_POPULATE_WRITE for writable mappings).

This feature should only be enabled during userfaultfd postcopy, as it
prevents the generation of async page faults.

The actual kernel changes to implement the change on arm64/x86 are
small: most of this series is actually just adding support for the new
feature in the demand paging self test. Performance samples (rates
reported in thousands of pages/s, average of five runs each) generated
using [2] on an x86 machine with 256 cores, are shown below.

vCPUs, Paging Rate (w/o new cap), Paging Rate (w/ new cap)
1       150     340
2       191     477
4       210     809
8       155     1239
16      130     1595
32      108     2299
64      86      3482
128     62      4134
256     36      4012

[1] https://lore.kernel.org/linux-mm/CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb0dNwiWiAN_Q@mail.gmail.com/
[2] ./demand_paging_test -b 64M -u MINOR -s shmem -a -v <n> -r <n> [-w]
    A quick rundown of the new flags (also detailed in later commits)
        -a registers all of guest memory to a single uffd.
        -r species the number of reader threads for polling the uffd.
        -w is what actually enables memory fault exits.
    All data was collected after applying the entire series.

This series is based on the latest kvm/next (7cb79f433e75).

Anish Moorthy (8):
  selftests/kvm: Fix bug in how demand_paging_test calculates paging
    rate
  selftests/kvm: Allow many vcpus per UFFD in demand paging test
  selftests/kvm: Switch demand paging uffd readers to epoll
  kvm: Allow hva_pfn_fast to resolve read-only faults.
  kvm: Add cap/kvm_run field for memory fault exits
  kvm/x86: Add mem fault exit on EPT violations
  kvm/arm64: Implement KVM_CAP_MEM_FAULT_NOWAIT for arm64
  selftests/kvm: Handle mem fault exits in demand paging test

 Documentation/virt/kvm/api.rst                |  42 ++++
 arch/arm64/kvm/arm.c                          |   1 +
 arch/arm64/kvm/mmu.c                          |  14 +-
 arch/x86/kvm/mmu/mmu.c                        |  23 +-
 arch/x86/kvm/x86.c                            |   1 +
 include/linux/kvm_host.h                      |  13 +
 include/uapi/linux/kvm.h                      |  13 +-
 tools/include/uapi/linux/kvm.h                |   7 +
 .../selftests/kvm/aarch64/page_fault_test.c   |   4 +-
 .../selftests/kvm/demand_paging_test.c        | 237 ++++++++++++++----
 .../selftests/kvm/include/userfaultfd_util.h  |  18 +-
 .../selftests/kvm/lib/userfaultfd_util.c      | 160 +++++++-----
 virt/kvm/kvm_main.c                           |  48 +++-
 13 files changed, 442 insertions(+), 139 deletions(-)

-- 
2.39.1.581.gbfd45094c4-goog

