Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0BEDC00140
	for <kvmarm@archiver.kernel.org>; Fri, 19 Aug 2022 00:57:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 724364CBF5;
	Thu, 18 Aug 2022 20:57:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6Pwat6ey-HOg; Thu, 18 Aug 2022 20:57:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 40C484CBD4;
	Thu, 18 Aug 2022 20:57:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BE8C4C9F0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Aug 2022 20:57:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5BuMJymEB3BV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Aug 2022 20:57:05 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43BCF4C391
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Aug 2022 20:57:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660870625;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WXZV61jfgDNJXnq5uwdk9hoJi8yzuP+++eERMshJ/0Q=;
 b=J0bVlkj5HfmJp2k53D3RdCeb6Q6OZZcckARLoOj5E/J/vKO72JJVWq+/4Jiv/BbPzeBtUw
 OoT5IuJxz/CM9hDtl4dNZ+eVOiKZWmqPkgdKjwnZcL6IVp/qpSWwsIshCWF5UHEE3OM1sR
 q20iQH665vDXV82JNuFYCfR1gUQyaHc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-VilcA4G8OhCHa0uI9An1Eg-1; Thu, 18 Aug 2022 20:57:01 -0400
X-MC-Unique: VilcA4G8OhCHa0uI9An1Eg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3A3C185A7B2;
 Fri, 19 Aug 2022 00:56:58 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-16.bne.redhat.com [10.64.54.16])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 09C02C15BB8;
 Fri, 19 Aug 2022 00:56:49 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 2/5] KVM: selftests: Use host page size to map ring buffer
 in dirty_log_test
Date: Fri, 19 Aug 2022 08:55:58 +0800
Message-Id: <20220819005601.198436-3-gshan@redhat.com>
In-Reply-To: <20220819005601.198436-1-gshan@redhat.com>
References: <20220819005601.198436-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kselftest@vger.kernel.org, bgardon@google.com, shuah@kernel.org,
 corbet@lwn.net, maz@kernel.org, shan.gavin@gmail.com, drjones@redhat.com,
 will@kernel.org, zhenyzha@redhat.com, dmatlack@google.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 pbonzini@redhat.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

In vcpu_map_dirty_ring(), the guest's page size is used to figure out
the offset in the virtual area. It works fine when we have same page
size on host and guest. However, it fails when the page sizes on host
and guest are different, like below error messages indicates. Actually,
the offset should be figured out according to host's page size. Otherwise,
the virtual area associated with the ring buffer can't be identified by
host.

  # ./dirty_log_test -M dirty-ring -m 7
  Setting log mode to: 'dirty-ring'
  Test iterations: 32, interval: 10 (ms)
  Testing guest mode: PA-bits:40,  VA-bits:48, 64K pages
  guest physical test memory offset: 0xffbffc0000
  vcpu stops because vcpu is kicked out...
  Notifying vcpu to continue
  vcpu continues now.
  ==== Test Assertion Failure ====
  lib/kvm_util.c:1477: addr == MAP_FAILED
  pid=9000 tid=9000 errno=0 - Success
  1  0x0000000000405f5b: vcpu_map_dirty_ring at kvm_util.c:1477
  2  0x0000000000402ebb: dirty_ring_collect_dirty_pages at dirty_log_test.c:349
  3  0x00000000004029b3: log_mode_collect_dirty_pages at dirty_log_test.c:478
  4  (inlined by) run_test at dirty_log_test.c:778
  5  (inlined by) run_test at dirty_log_test.c:691
  6  0x0000000000403a57: for_each_guest_mode at guest_modes.c:105
  7  0x0000000000401ccf: main at dirty_log_test.c:921
  8  0x0000ffffb06ec79b: ?? ??:0
  9  0x0000ffffb06ec86b: ?? ??:0
  10 0x0000000000401def: _start at ??:?
  Dirty ring mapped private

Fix the issue by using host's page size to map the ring buffer.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9889fe0d8919..4e823cbe6b48 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1464,7 +1464,7 @@ struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vcpu *vcpu)
 
 void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu)
 {
-	uint32_t page_size = vcpu->vm->page_size;
+	uint32_t page_size = getpagesize();
 	uint32_t size = vcpu->vm->dirty_ring_size;
 
 	TEST_ASSERT(size > 0, "Should enable dirty ring first");
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
