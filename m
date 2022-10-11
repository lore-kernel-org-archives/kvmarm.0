Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8460417DB
	for <kvmarm@lists.linux.dev>; Tue, 11 Oct 2022 06:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665469395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WLI+aljRSNCxVUOqrV7FVkwTmL1Khz0KUGashv50XQ=;
	b=Ss8QDM4pE22exoRX5GQQYyZHI7tPwhUi8uC0oN843RgEQDfDyM+uZ4qid/3D+Q4gJKXO4k
	AvL1OTgbWGrgMv8DLjSsibUHnXklfjodvrLPYYstvjchBYijjA8cjWDq86fhI3zE3OLKpy
	Uy4j+woedN9eM+1lBBEjeVHH9WAO51k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-_nX2sNEHM3idwAfv-F428w-1; Tue, 11 Oct 2022 02:23:09 -0400
X-MC-Unique: _nX2sNEHM3idwAfv-F428w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 355CA299E740;
	Tue, 11 Oct 2022 06:23:09 +0000 (UTC)
Received: from [10.64.54.52] (vpn2-54-52.bne.redhat.com [10.64.54.52])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 19B13477F5C;
	Tue, 11 Oct 2022 06:23:03 +0000 (UTC)
Subject: Re: [PATCH v6 0/8] KVM: arm64: Enable ring-based dirty memory
 tracking
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev
Cc: shuah@kernel.org, kvm@vger.kernel.org, maz@kernel.org,
 bgardon@google.com, andrew.jones@linux.dev, shan.gavin@gmail.com,
 catalin.marinas@arm.com, dmatlack@google.com, pbonzini@redhat.com,
 zhenyzha@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 oliver upton <oliver.upton@linux.dev>,
 Sean Christopherson <seanjc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20221011061447.131531-1-gshan@redhat.com>
Message-ID: <3123a04f-a674-782b-9e9b-0baf3db49ebc@redhat.com>
Date: Tue, 11 Oct 2022 14:23:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20221011061447.131531-1-gshan@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Message-ID: <20221011062301.n6w6_BEhi9r7UEq8T0lGZSBCwle2_cgPXXvoEG5tDWc@z>

On 10/11/22 2:14 PM, Gavin Shan wrote:
> This series enables the ring-based dirty memory tracking for ARM64.
> The feature has been available and enabled on x86 for a while. It
> is beneficial when the number of dirty pages is small in a checkpointing
> system or live migration scenario. More details can be found from
> fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking").
> 
> This series is applied on top of Marc's v2 series [0], fixing dirty-ring
> ordering issue. This series is going to land on v6.1.rc0 pretty soon.
> 
> [0] https://lore.kernel.org/kvmarm/20220926145120.27974-1-maz@kernel.org
> 
> v5: https://lore.kernel.org/all/20221005004154.83502-1-gshan@redhat.com/
> v4: https://lore.kernel.org/kvmarm/20220927005439.21130-1-gshan@redhat.com/
> v3: https://lore.kernel.org/r/20220922003214.276736-1-gshan@redhat.com
> v2: https://lore.kernel.org/lkml/YyiV%2Fl7O23aw5aaO@xz-m1.local/T/
> v1: https://lore.kernel.org/lkml/20220819005601.198436-1-gshan@redhat.com
> 
> Testing
> =======
> (1) kvm/selftests/dirty_log_test
> (2) Live migration by QEMU
> 
> Changelog
> =========
> v6:
>    * Add CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP, for arm64
>      to advertise KVM_CAP_DIRTY_RING_WITH_BITMAP in
>      PATCH[v6 3/8]                                              (Oliver/Peter)
>    * Add helper kvm_dirty_ring_exclusive() to check if
>      traditional bitmap-based dirty log tracking is
>      exclusive to dirty-ring in PATCH[v6 3/8]                   (Peter)
>    * Enable KVM_CAP_DIRTY_RING_WITH_BITMAP in PATCH[v6 5/8]     (Gavin)
> v5:
>    * Drop empty stub kvm_dirty_ring_check_request()             (Marc/Peter)
>    * Add PATCH[v5 3/7] to allow using bitmap, indicated by
>      KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP                        (Marc/Peter)
> v4:
>    * Commit log improvement                                     (Marc)
>    * Add helper kvm_dirty_ring_check_request()                  (Marc)
>    * Drop ifdef for kvm_cpu_dirty_log_size()                    (Marc)
> v3:
>    * Check KVM_REQ_RING_SOFT_RULL inside kvm_request_pending()  (Peter)
>    * Move declaration of kvm_cpu_dirty_log_size()               (test-robot)
> v2:
>    * Introduce KVM_REQ_RING_SOFT_FULL                           (Marc)
>    * Changelog improvement                                      (Marc)
>    * Fix dirty_log_test without knowing host page size          (Drew)
> 
> Gavin Shan (8):
>    KVM: x86: Introduce KVM_REQ_RING_SOFT_FULL
>    KVM: x86: Move declaration of kvm_cpu_dirty_log_size() to
>      kvm_dirty_ring.h
>    KVM: Add support for using dirty ring in conjunction with bitmap
>    KVM: arm64: Enable ring-based dirty memory tracking
>    KVM: selftests: Enable KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP if possible
>    KVM: selftests: Use host page size to map ring buffer in
>      dirty_log_test
>    KVM: selftests: Clear dirty ring states between two modes in
>      dirty_log_test
>    KVM: selftests: Automate choosing dirty ring size in dirty_log_test
> 
>   Documentation/virt/kvm/api.rst               | 19 ++++---
>   arch/arm64/include/uapi/asm/kvm.h            |  1 +
>   arch/arm64/kvm/Kconfig                       |  2 +
>   arch/arm64/kvm/arm.c                         |  3 ++
>   arch/x86/include/asm/kvm_host.h              |  2 -
>   arch/x86/kvm/x86.c                           | 15 +++---
>   include/linux/kvm_dirty_ring.h               | 15 +++---
>   include/linux/kvm_host.h                     |  2 +
>   include/uapi/linux/kvm.h                     |  1 +
>   tools/testing/selftests/kvm/dirty_log_test.c | 53 ++++++++++++++------
>   tools/testing/selftests/kvm/lib/kvm_util.c   |  5 +-
>   virt/kvm/Kconfig                             |  8 +++
>   virt/kvm/dirty_ring.c                        | 24 ++++++++-
>   virt/kvm/kvm_main.c                          | 34 +++++++++----
>   14 files changed, 132 insertions(+), 52 deletions(-)
> 

It seems Oliver and Sean were missed in the loop, even though I explicitly
copied them by git-send-email. Amend to include them.

Thanks,
Gavin

