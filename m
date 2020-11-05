Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC2CC00A89
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 09:12:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9668A2071A
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 09:12:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HryRBPi3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9668A2071A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 02BE14B7D2;
	Thu,  5 Nov 2020 04:12:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VlXKxeccbqm5; Thu,  5 Nov 2020 04:12:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E72E44B7BE;
	Thu,  5 Nov 2020 04:12:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2F754B3A1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 04:12:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K0X8cglgGBZC for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 04:12:11 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5E7F4B368
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 04:12:11 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604567531;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=KJk57qFGnDBMFxFH3XJU98lSAGfOtWv+ZIi/vHNtQIU=;
 b=HryRBPi3y50iliHMwYvQBy5GARJEHUiuAW9TVMMHgXO36z0ydYccpz2UR0ntMr0rsTW12D
 foStXJZzB22hdAj8u4hitbiJC60X/23AzLHf4P2nzqLG7grONaphCVKxR69dd26/uASlBS
 eNH2uxR4ZHVLEaD2zanDEO4UAKICEVY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-e16BLnkoO-y8yscRGtB9VQ-1; Thu, 05 Nov 2020 04:10:27 -0500
X-MC-Unique: e16BLnkoO-y8yscRGtB9VQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4394E107ACF6;
 Thu,  5 Nov 2020 09:10:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.18])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 79D7860C17;
 Thu,  5 Nov 2020 09:10:24 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 0/4] KVM: arm64: Fix get-reg-list regression
Date: Thu,  5 Nov 2020 10:10:18 +0100
Message-Id: <20201105091022.15373-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, xu910121@sina.com, Dave.Martin@arm.com
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

5byg5Lic5petIDx4dTkxMDEyMUBzaW5hLmNvbT4gcmVwb3J0ZWQgYSByZWdyZXNzaW9uIHNlZW4g
d2l0aCBDZW50T1MKd2hlbiBtaWdyYXRpbmcgZnJvbSBhbiBvbGQga2VybmVsIHRvIGEgbmV3IG9u
ZS4gVGhlIHByb2JsZW0gd2FzCnRoYXQgUUVNVSByZWplY3RlZCB0aGUgbWlncmF0aW9uIHNpbmNl
IEtWTV9HRVRfUkVHX0xJU1QgcmVwb3J0ZWQKYSByZWdpc3RlciB3YXMgbWlzc2luZyBvbiB0aGUg
ZGVzdGluYXRpb24uIEV4dHJhIHJlZ2lzdGVycyBhcmUgT0sKb24gdGhlIGRlc3RpbmF0aW9uLCBi
dXQgbm90IG1pc3Npbmcgb25lcy4gVGhlIHJlZ3Jlc3Npb24gcmVwcm9kdWNlcwp3aXRoIHVwc3Ry
ZWFtIGtlcm5lbHMgd2hlbiBtaWdyYXRpbmcgZnJvbSBhIDQuMTUgb3IgbGF0ZXIga2VybmVsLAp1
cCB0byBvbmUgd2l0aCBjb21taXQgNzM0MzM3NjJmY2FlICgiS1ZNOiBhcm02NC9zdmU6IFN5c3Rl
bSByZWdpc3Rlcgpjb250ZXh0IHN3aXRjaCBhbmQgYWNjZXNzIHN1cHBvcnQiKSwgdG8gYSBrZXJu
ZWwgdGhhdCBpbmNsdWRlcyB0aGF0CmNvbW1pdCwgZS5nLiB0aGUgbGF0ZXN0IG1haW5saW5lICg1
LjEwLXJjMikuCgpUaGUgZmlyc3QgcGF0Y2ggb2YgdGhpcyBzZXJpZXMgaXMgdGhlIGZpeC4gVGhl
IG5leHQgdHdvIHBhdGNoZXMsCndoaWNoIGRvbid0IGhhdmUgYW55IGludGVuZGVkIGZ1bmN0aW9u
YWwgY2hhbmdlcywgYWxsb3cgSURfU0FOSVRJU0VECnRvIGJlIHVzZWQgZm9yIHJlZ2lzdGVycyB0
aGF0IGZsaXAgYmV0d2VlbiBleHBvc2luZyBmZWF0dXJlcyBhbmQKYmVpbmcgUkFaLCB3aGljaCBh
bGxvd3Mgc29tZSBjb2RlIHRvIGJlIHJlbW92ZWQuCgp2MzoKIC0gSW1wcm92ZSBjb21taXQgbWVz
c2FnZXMgW0RhdmVdCiAtIEFkZCBuZXcgcGF0Y2ggdG8gY29uc29saWRhdGUgUkVHX0hJRERFTiog
ZmxhZ3MgW0RhdmVdCgp2MjoKIC0gQ0Mgc3RhYmxlIFtNYXJjXQogLSBPbmx5IG9uZSBSQVogZmxh
ZyBpcyBlbm91Z2ggW01hcmNdCiAtIE1vdmUgaWRfdmlzaWJpbGl0eSgpIHVwIGJ5IHJlYWRfaWRf
cmVnKCkgc2luY2UgdGhleSdsbCBsaWtlbHkKICAgYmUgbWFpbnRhaW5lZCB0b2dldGhlciBbZHJl
d10KCgpBbmRyZXcgSm9uZXMgKDQpOgogIEtWTTogYXJtNjQ6IERvbid0IGhpZGUgSUQgcmVnaXN0
ZXJzIGZyb20gdXNlcnNwYWNlCiAgS1ZNOiBhcm02NDogQ29uc29saWRhdGUgUkVHX0hJRERFTl9H
VUVTVC9VU0VSCiAgS1ZNOiBhcm02NDogQ2hlY2sgUkFaIHZpc2liaWxpdHkgaW4gSUQgcmVnaXN0
ZXIgYWNjZXNzb3JzCiAgS1ZNOiBhcm02NDogUmVtb3ZlIEFBNjRaRlIwX0VMMSBhY2Nlc3NvcnMK
CiBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jIHwgMTA4ICsrKysrKysrKysrKy0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tCiBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5oIHwgIDE2ICsrKy0tLQog
MiBmaWxlcyBjaGFuZ2VkLCA0MSBpbnNlcnRpb25zKCspLCA4MyBkZWxldGlvbnMoLSkKCi0tIAoy
LjI2LjIKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2
bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
