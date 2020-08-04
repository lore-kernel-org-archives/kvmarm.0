Return-Path: <SRS0=bLIx=BO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A19FC433DF
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 13:46:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 23B9C2075D
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 13:46:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebOiwiw6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23B9C2075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C8AB4B6F8;
	Tue,  4 Aug 2020 09:46:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wS7ghhtsiJOr; Tue,  4 Aug 2020 09:46:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 94C954B711;
	Tue,  4 Aug 2020 09:46:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A30B4B6F8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 09:46:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YaoVuNOZM6wU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2020 09:46:29 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F3A94B6F6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 09:46:29 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4EE162075D;
 Tue,  4 Aug 2020 13:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596548788;
 bh=roMCFNmPPkY9aOtB8mbdYYu8t78Z3ZS0O3Rhws1u9uE=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=ebOiwiw6ObunrZDT7PrvjzIBqiWke7wA41Iayk6OkmK6KmXuDxquLSr6joJ6RQz6D
 9zdmERHtU5Z+zeY4147ZiponZGJgLvcc98Y+Nzaargz1rPGaZMCR1UrttQMh1Jun8c
 aDQFAOYaJRFhnGNldBQbEEjc2jAiqKKBlbxvNxZk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k2xGs-00HOpC-P7; Tue, 04 Aug 2020 14:46:26 +0100
MIME-Version: 1.0
Date: Tue, 04 Aug 2020 14:46:26 +0100
From: Marc Zyngier <maz@kernel.org>
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH  v1 3/3] kernel/configs: don't include PCI_QUIRKS in KVM
 guest configs
In-Reply-To: <20200804124417.27102-4-alex.bennee@linaro.org>
References: <20200804124417.27102-1-alex.bennee@linaro.org>
 <20200804124417.27102-4-alex.bennee@linaro.org>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <f80cfa932a650d8f7e8fc02a1656b4c2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alex.bennee@linaro.org, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMC0wOC0wNCAxMzo0NCwgQWxleCBCZW5uw6llIHdyb3RlOgo+IFRoZSBWSVJUSU9fUENJ
IHN1cHBvcnQgaXMgYW4gaWRlYWxpc2VkIFBDSSBidXMsIHdlIGRvbid0IG5lZWQgYSBidW5jaAo+
IG9mIGJsb2F0IGZvciByZWFsIHdvcmxkIGhhcmR3YXJlIGZvciBhIFZpcnRJTyBndWVzdC4KCldo
byBzYXlzIHRoaXMgZ3Vlc3Qgd2lsbCBvbmx5IGhhdmUgdmlydGlvIGRldmljZXM/CgpPciBldmVu
LCB2aXJ0aW8gZGV2aWNlcyB3aXRob3V0IGJ1Z3M/IEdpdmVuIHRoYXQgc2FpZCBkZXZpY2UgY2Fu
CmNvbWUgZnJvbSBhbnkgVk1NLCBJJ20gbm90IHN1cmUgdGhpcyBpcyB0aGUgcmlnaHQgdGhpbmcg
dG8gZG8uCgpUaGFua3MsCgogICAgICAgICBNLgoKPiAKPiBTaWduZWQtb2ZmLWJ5OiBBbGV4IEJl
bm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+Cj4gLS0tCj4gIGtlcm5lbC9jb25maWdzL2t2
bV9ndWVzdC5jb25maWcgfCAxICsKPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCj4g
Cj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9jb25maWdzL2t2bV9ndWVzdC5jb25maWcgCj4gYi9rZXJu
ZWwvY29uZmlncy9rdm1fZ3Vlc3QuY29uZmlnCj4gaW5kZXggMjA4NDgxZDkxMDkwLi42NzI4NjNh
MmZkZjEgMTAwNjQ0Cj4gLS0tIGEva2VybmVsL2NvbmZpZ3Mva3ZtX2d1ZXN0LmNvbmZpZwo+ICsr
KyBiL2tlcm5lbC9jb25maWdzL2t2bV9ndWVzdC5jb25maWcKPiBAQCAtMTMsNiArMTMsNyBAQCBD
T05GSUdfSVBfUE5QX0RIQ1A9eQo+ICBDT05GSUdfQklORk1UX0VMRj15Cj4gIENPTkZJR19QQ0k9
eQo+ICBDT05GSUdfUENJX01TST15Cj4gK0NPTkZJR19QQ0lfUVVJUktTPW4KPiAgQ09ORklHX0RF
QlVHX0tFUk5FTD15Cj4gIENPTkZJR19WSVJUVUFMSVpBVElPTj15Cj4gIENPTkZJR19IWVBFUlZJ
U09SX0dVRVNUPXkKCi0tIApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4u
LgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
