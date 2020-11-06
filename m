Return-Path: <SRS0=uq+A=EM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75582C2D0A3
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 16:35:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A74C1217A0
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 16:35:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0nJBV8I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A74C1217A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F4E24B8AE;
	Fri,  6 Nov 2020 11:35:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xib6qD8qI9mL; Fri,  6 Nov 2020 11:35:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 220694B89F;
	Fri,  6 Nov 2020 11:35:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09E354B89E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 11:35:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oh1DhAlU6tS3 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Nov 2020 11:35:32 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 163DD4B7EF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 11:35:32 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8EF3C2151B;
 Fri,  6 Nov 2020 16:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604680530;
 bh=JyOH9iTVTx2BTJ1PJthxuRBaC92YJVIFBanxKg/HH7w=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=i0nJBV8IUxjIL0HtIUFmfX549jLxlc/M3M02gloMZpq3jz3XLLPd5k0FFdH/fouse
 wOxuH4DF3lFZXFcDLkD6A+tP04jXuFclgYDgkCI5sF1/h6WLka3Jdj14NEgdXS1Iqu
 qeRlTWQmEXpUBaYo67jvUBZWT56GZVRC5fwCZZ9Y=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=wait-a-minute.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kb4i0-008FRC-CK; Fri, 06 Nov 2020 16:35:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v3 0/4] KVM: arm64: Fix get-reg-list regression
Date: Fri,  6 Nov 2020 16:35:19 +0000
Message-Id: <160468048426.137782.8832651849228371483.b4-ty@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201105091022.15373-1-drjones@redhat.com>
References: <20201105091022.15373-1-drjones@redhat.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvmarm@lists.cs.columbia.edu,
 xu910121@sina.com, Dave.Martin@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: xu910121@sina.com, Dave.Martin@arm.com
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

T24gVGh1LCA1IE5vdiAyMDIwIDEwOjEwOjE4ICswMTAwLCBBbmRyZXcgSm9uZXMgd3JvdGU6Cj4g
5byg5Lic5petIDx4dTkxMDEyMUBzaW5hLmNvbT4gcmVwb3J0ZWQgYSByZWdyZXNzaW9uIHNlZW4g
d2l0aCBDZW50T1MKPiB3aGVuIG1pZ3JhdGluZyBmcm9tIGFuIG9sZCBrZXJuZWwgdG8gYSBuZXcg
b25lLiBUaGUgcHJvYmxlbSB3YXMKPiB0aGF0IFFFTVUgcmVqZWN0ZWQgdGhlIG1pZ3JhdGlvbiBz
aW5jZSBLVk1fR0VUX1JFR19MSVNUIHJlcG9ydGVkCj4gYSByZWdpc3RlciB3YXMgbWlzc2luZyBv
biB0aGUgZGVzdGluYXRpb24uIEV4dHJhIHJlZ2lzdGVycyBhcmUgT0sKPiBvbiB0aGUgZGVzdGlu
YXRpb24sIGJ1dCBub3QgbWlzc2luZyBvbmVzLiBUaGUgcmVncmVzc2lvbiByZXByb2R1Y2VzCj4g
d2l0aCB1cHN0cmVhbSBrZXJuZWxzIHdoZW4gbWlncmF0aW5nIGZyb20gYSA0LjE1IG9yIGxhdGVy
IGtlcm5lbCwKPiB1cCB0byBvbmUgd2l0aCBjb21taXQgNzM0MzM3NjJmY2FlICgiS1ZNOiBhcm02
NC9zdmU6IFN5c3RlbSByZWdpc3Rlcgo+IGNvbnRleHQgc3dpdGNoIGFuZCBhY2Nlc3Mgc3VwcG9y
dCIpLCB0byBhIGtlcm5lbCB0aGF0IGluY2x1ZGVzIHRoYXQKPiBjb21taXQsIGUuZy4gdGhlIGxh
dGVzdCBtYWlubGluZSAoNS4xMC1yYzIpLgo+IAo+IFsuLi5dCgpBcHBsaWVkIHRvIG5leHQsIHRo
YW5rcyEKClsxLzRdIEtWTTogYXJtNjQ6IERvbid0IGhpZGUgSUQgcmVnaXN0ZXJzIGZyb20gdXNl
cnNwYWNlCiAgICAgIGNvbW1pdDogZjgxY2IyYzNhZDQxYWM2ZDhjYjI2NTBlM2Q3MmQ1ZjY3ZGIx
YWEyOApbMi80XSBLVk06IGFybTY0OiBDb25zb2xpZGF0ZSBSRUdfSElEREVOX0dVRVNUL1VTRVIK
ICAgICAgY29tbWl0OiAwMWZlNWFjZTkyZGRiODczMmUzMzMxMzU1ZTdiYTljYjZmMmVmNzg3Clsz
LzRdIEtWTTogYXJtNjQ6IENoZWNrIFJBWiB2aXNpYmlsaXR5IGluIElEIHJlZ2lzdGVyIGFjY2Vz
c29ycwogICAgICBjb21taXQ6IDkxMmRlZTU3MjY5MWZmYjJiMzg3ZGQ4YjRmMTgzZDU0OWE2YjI0
ZDEKWzQvNF0gS1ZNOiBhcm02NDogUmVtb3ZlIEFBNjRaRlIwX0VMMSBhY2Nlc3NvcnMKICAgICAg
Y29tbWl0OiBjNTEyMjk4ZWVkMDM2MDkyM2QwY2JjNGExZjMwYmMwNTA5YWYwZDUwCgpDaGVlcnMs
CgoJTS4KLS0gCldpdGhvdXQgZGV2aWF0aW9uIGZyb20gdGhlIG5vcm0sIHByb2dyZXNzIGlzIG5v
dCBwb3NzaWJsZS4KCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
