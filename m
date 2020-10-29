Return-Path: <SRS0=BReL=EE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 593D6C2D0A3
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 20:11:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 71D01206DD
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 20:11:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DzHX12ZX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71D01206DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99FDB4B664;
	Thu, 29 Oct 2020 16:11:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YP1j-D+-8h7n; Thu, 29 Oct 2020 16:11:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 789F34B629;
	Thu, 29 Oct 2020 16:11:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D05304B5EB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 16:11:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 94CQ3NLnveDB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Oct 2020 16:11:13 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0268A4B5E8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 16:11:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604002272;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding;
 bh=Tyb8FK5K66va2yhPKLsGL2I54Q1Vv0WaI50wKnda8jY=;
 b=DzHX12ZXjri9KzPWgVj0cUCJDjFQIsJKo0alguqj4GkKDOUminlVZow0Dh6KoudeecvGHO
 CXX0PJ4288NJkFyXjI+QiOUzAeSP9cLWFXGm82ILY4jXYESbVJMP7aGHcTOISNQIao65lf
 ea4uXcCe+trxHy0PEdMkDQ92yW5Wl+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-UOS6jPAMPiGvakb05KgWhA-1; Thu, 29 Oct 2020 16:11:10 -0400
X-MC-Unique: UOS6jPAMPiGvakb05KgWhA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DC5318BA282;
 Thu, 29 Oct 2020 20:11:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.219])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 64C8F5C22D;
 Thu, 29 Oct 2020 20:11:07 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/3] KVM: arm64: Fix get-reg-list regression
Date: Thu, 29 Oct 2020 21:11:02 +0100
Message-Id: <20201029201105.101910-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
LjEwLXJjMSkuCgpUaGUgZmlyc3QgcGF0Y2ggb2YgdGhpcyBzZXJpZXMgaXMgdGhlIGZpeC4gVGhl
IG5leHQgdHdvIHBhdGNoZXMsCndoaWNoIGRvbid0IGhhdmUgYW55IGludGVuZGVkIGZ1bmN0aW9u
YWwgY2hhbmdlcywgYWxsb3cgSURfU0FOSVRJU0VECnRvIGJlIHVzZWQgZm9yIHJlZ2lzdGVycyB0
aGF0IGZsaXAgYmV0d2VlbiBleHBvc2luZyBmZWF0dXJlcyBhbmQKYmVpbmcgUkFaLCB3aGljaCBh
bGxvd3Mgc29tZSBjb2RlIHRvIGJlIHJlbW92ZWQuCgpBbmRyZXcgSm9uZXMgKDMpOgogIEtWTTog
YXJtNjQ6IERvbid0IGhpZGUgSUQgcmVnaXN0ZXJzIGZyb20gdXNlcnNwYWNlCiAgS1ZNOiBhcm02
NDogQ2hlY2sgUkFaIHZpc2liaWxpdHkgaW4gSUQgcmVnaXN0ZXIgYWNjZXNzb3JzCiAgS1ZNOiBh
cm02NDogUmVtb3ZlIEFBNjRaRlIwX0VMMSBhY2Nlc3NvcnMKCiBhcmNoL2FybTY0L2t2bS9zeXNf
cmVncy5jIHwgOTYgKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiBhcmNo
L2FybTY0L2t2bS9zeXNfcmVncy5oIHwgMjAgKysrKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgNDcg
aW5zZXJ0aW9ucygrKSwgNjkgZGVsZXRpb25zKC0pCgotLSAKMi4yNy4wCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
