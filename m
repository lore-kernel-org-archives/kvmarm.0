Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD54B4699
	for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 19:58:42 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id n6-20020a5b0486000000b006aff8dc9865so11401488ybp.11
        for <kvmarm@lists.linux.dev>; Mon, 17 Oct 2022 12:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=frMbmYegxOtgtF+Jjq9ubWz1wi/u8FMIRL0o35ogzl4=;
        b=FVyKm8AJ9lqnXFMnIVBf1tOS8wOQDtJ+Xy2Uop4XBqDNwL3RFWY+6erwzCG4KmxWyA
         WZy+dunuyl1K6cd9rROWRme5kGxDBVofrIEsB3JBAKNLqikP1XSuHM9j14eHUUeImxqk
         qX1+Dll/EhKGvxElhbloQzt2Lhb7zAmFtayUrXTAoCHswiZl5ohjLjTsqMTTh7zgp3mA
         nhe1psiyPBvpZW/NFmG+yf3uxq0ibbR1GQ59RjnF+lJvUqyZqNf0q+03LpGnBEk9YPRk
         RXbOgoJpQfT9u9z4ldIcQPCmSwQ/sveTptXYaLP+g658y8kJAW218iP5/44HgdcEZA7e
         r+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=frMbmYegxOtgtF+Jjq9ubWz1wi/u8FMIRL0o35ogzl4=;
        b=nfWJ1G5e70Fu/QBh4wsAqV8BxXe3eqvNUZTSlRj6DnDeAi6hNdWvMPh5VldBksB1Iq
         1qAdxVxqHfXF2yVrTT3qXukJGqQbrUDf3Mnhxt9QJGR/b2SdR0vLdfVTWCD50LTY06+3
         tOipMLDCz5H7+C/ueC7Yspt3J17dqaPcvNx1YYMPWaZG0OPCSwszESs2mEDoDAPHRkeC
         X9Hg/sbxtZN6udv6o6MDqDGKFj/2b/vkUQ5rHj0WvjTX87qTJR3OP1Swx5a6uWKfX1zs
         wPVLEogBhlOIJEDhgWdfq/NbkIv4FmtoOn5VjCIwkhK2/9CQ8e1hZnOZqMgVoKKOM6eV
         1aSw==
X-Gm-Message-State: ACrzQf24VWeAk2R6/O/ZRO8QFU+Bdx5OiNIvCLLAQoeMz5jW9gg0FLjV
	+G+bAHfN1yZ1MrUX0T4WM3de3TtA6Hb1dg==
X-Google-Smtp-Source: AMsMyM4tK2eFk3WKl8NqSllJ5w9+Cb5/5+XGTB1ov7n5qva2uCfQFWIm97I3xkvFqYDqfYIWH+X6VbW9OzHK4g==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:4004:0:b0:6bd:5cd:9f60 with SMTP id
 n4-20020a254004000000b006bd05cd9f60mr11379639yba.292.1666036721981; Mon, 17
 Oct 2022 12:58:41 -0700 (PDT)
Date: Mon, 17 Oct 2022 19:58:23 +0000
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-4-ricarkol@google.com>
Subject: [PATCH v10 03/14] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete()
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, seanjc@google.com, 
	alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221017195823.ws7n_h8MjC8zOZ8zebr6ZBA4J3oGTjZcFv269xlO_TE@z>

Deleting a memslot (when freeing a VM) is not closing the backing fd,
nor it's unmapping the alias mapping. Fix by adding the missing close
and munmap.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f1cb1627161f..19e37fb7de7c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -586,6 +586,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	sparsebit_free(&region->unused_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+	if (region->fd >= 0) {
+		/* There's an extra map when using shared memory. */
+		ret = munmap(region->mmap_alias, region->mmap_size);
+		TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+		close(region->fd);
+	}
 
 	free(region);
 }
-- 
2.38.0.413.g74048e4d9e-goog

