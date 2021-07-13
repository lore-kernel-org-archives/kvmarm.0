Return-Path: <SRS0=yjsw=MF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F07B5C07E95
	for <kvmarm@archiver.kernel.org>; Tue, 13 Jul 2021 20:37:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89BF961362
	for <kvmarm@archiver.kernel.org>; Tue, 13 Jul 2021 20:37:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89BF961362
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C0754B08C;
	Tue, 13 Jul 2021 16:37:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YrUgvlCnrsUA; Tue, 13 Jul 2021 16:37:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AE504AEF8;
	Tue, 13 Jul 2021 16:37:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 186B14A1A7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Jul 2021 16:37:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oVX5lXWmsZ-H for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Jul 2021 16:37:47 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5985F4A4BE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Jul 2021 16:37:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626208667;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Xy/M8DyJhkeHcfgLxk1yBVOnSySApjGIhNjf8/Qokmo=;
 b=OgWvRM0Q5/Ci2Hca3xY/KsEmuQLMMKVdvRJKED2/UmAqqCy+M3FNfWNwgBG0Z/621yB/iE
 VLIXzUaBdh/ILlaEihaRgO5QLwMoPSGYB+p/EFlz6NtiD83PDTdrsPbg0R6QDYIfFAf2tU
 EDQgDBbr8z8ut93Ljx6Xt/0M5RC70e4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-PpdtELlKPxWgPnX-vBHNYQ-1; Tue, 13 Jul 2021 16:37:46 -0400
X-MC-Unique: PpdtELlKPxWgPnX-vBHNYQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEBBA801107;
 Tue, 13 Jul 2021 20:37:44 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.22.8.235])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 270541002D71;
 Tue, 13 Jul 2021 20:37:44 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/2] KVM: selftests: change pthread_yield to sched_yield
Date: Tue, 13 Jul 2021 22:37:41 +0200
Message-Id: <20210713203742.29680-2-drjones@redhat.com>
In-Reply-To: <20210713203742.29680-1-drjones@redhat.com>
References: <20210713203742.29680-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: maz@kernel.org, pbonzini@redhat.com
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

V2l0aCBsYXRlciBHQ0Mgd2UgZ2V0Cgogc3RlYWxfdGltZS5jOiBJbiBmdW5jdGlvbiDigJhtYWlu
4oCZOgogc3RlYWxfdGltZS5jOjMyMzoyNTogd2FybmluZzog4oCYcHRocmVhZF95aWVsZOKAmSBp
cyBkZXByZWNhdGVkOiBwdGhyZWFkX3lpZWxkIGlzIGRlcHJlY2F0ZWQsIHVzZSBzY2hlZF95aWVs
ZCBpbnN0ZWFkIFstV2RlcHJlY2F0ZWQtZGVjbGFyYXRpb25zXQoKTGV0J3MgZm9sbG93IHRoZSBp
bnN0cnVjdGlvbnMgYW5kIHVzZSBzY2hlZF95aWVsZCBpbnN0ZWFkLgoKU2lnbmVkLW9mZi1ieTog
QW5kcmV3IEpvbmVzIDxkcmpvbmVzQHJlZGhhdC5jb20+Ci0tLQogdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMva3ZtL3N0ZWFsX3RpbWUuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2t2bS9zdGVhbF90aW1lLmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vc3RlYWxfdGlt
ZS5jCmluZGV4IGIwMDMxZjJkMzhmZC4uZWNlYzMwODY1YTc0IDEwMDY0NAotLS0gYS90b29scy90
ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vc3RlYWxfdGltZS5jCisrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2Vs
ZnRlc3RzL2t2bS9zdGVhbF90aW1lLmMKQEAgLTMyMCw3ICszMjAsNyBAQCBpbnQgbWFpbihpbnQg
YWMsIGNoYXIgKiphdikKIAkJcnVuX2RlbGF5ID0gZ2V0X3J1bl9kZWxheSgpOwogCQlwdGhyZWFk
X2NyZWF0ZSgmdGhyZWFkLCAmYXR0ciwgZG9fc3RlYWxfdGltZSwgTlVMTCk7CiAJCWRvCi0JCQlw
dGhyZWFkX3lpZWxkKCk7CisJCQlzY2hlZF95aWVsZCgpOwogCQl3aGlsZSAoZ2V0X3J1bl9kZWxh
eSgpIC0gcnVuX2RlbGF5IDwgTUlOX1JVTl9ERUxBWV9OUyk7CiAJCXB0aHJlYWRfam9pbih0aHJl
YWQsIE5VTEwpOwogCQlydW5fZGVsYXkgPSBnZXRfcnVuX2RlbGF5KCkgLSBydW5fZGVsYXk7Ci0t
IAoyLjMxLjEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
