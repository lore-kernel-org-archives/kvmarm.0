Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7645DC433F5
	for <kvmarm@archiver.kernel.org>; Tue,  8 Feb 2022 17:37:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C9EF4A0FC;
	Tue,  8 Feb 2022 12:37:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DdTfgLkwaAC2; Tue,  8 Feb 2022 12:37:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 347C64B183;
	Tue,  8 Feb 2022 12:37:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3792B4B128
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:37:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ekr+fSIPgAF2 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Feb 2022 12:37:32 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A859D4B0F4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Feb 2022 12:37:32 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id BF456B81CBA;
 Tue,  8 Feb 2022 17:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585C6C004E1;
 Tue,  8 Feb 2022 17:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1644341850;
 bh=t26HgygNCh8gCfuTN/ojA3LnBOvxFUkG2+R14a7qPUY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ZDXHH6KXySyqGenuzjikTOkmMlmgn61tcGHp65CJstK7pekDYRNyzdPbsWcUdRHMa
 be9t0aqXdDBJZb2jh3M2ctzvjGKPhT2+U8miu88OGgesRiFS9qXr3dc9MBm6tagmwz
 vOEQKiTzfNU/5ARKxOpFxgcWjZ7pTKxkjlDZxqjKohjn1KxVvI9YexxZfQo0TFibwA
 2W1FOUJIJrluOsvh9LjXLg79eDMJ/gQF0HttM5iJCclCaGPPEvvIuxcp0nd2NYkoIP
 JaWnyT/RDPoiM/SXeYzlWDGxq1lDtrtgq5PPZG7Hy+jHEZijyvDHudQ9opSnqKHdZW
 NO2nOr+ZV8syw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nHUQi-006Ksl-E4; Tue, 08 Feb 2022 17:37:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v4 0/4] kvm/arm: New VMID allocator based on asid
Date: Tue,  8 Feb 2022 17:37:27 +0000
Message-Id: <164434147328.3931943.1270605694385749340.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211122121844.867-1-shameerali.kolothum.thodi@huawei.com>
References: <20211122121844.867-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 shameerali.kolothum.thodi@huawei.com, will@kernel.org,
 jonathan.cameron@huawei.com, Alexandru.Elisei@arm.com, catalin.marinas@arm.com,
 linuxarm@huawei.com, jean-philippe@linaro.org, qperret@google.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, james.morse@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: jean-philippe@linaro.org, will@kernel.org, jonathan.cameron@huawei.com,
 linuxarm@huawei.com, catalin.marinas@arm.com
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

T24gTW9uLCAyMiBOb3YgMjAyMSAxMjoxODo0MCArMDAwMCwgU2hhbWVlciBLb2xvdGh1bSB3cm90
ZToKPiBDaGFuZ2VzIGZyb20gdjM6Cj4gLSBNYWluIGNoYW5nZSBpcyBpbiBwYXRjaCAjNCwgd2hl
cmUgdGhlIFZNSUQgaXMgbm93IHNldCB0byBhbgo+ICAgaW52YWxpZCBvbmUgb24gdkNQVSBzY2hl
ZHVsZSBvdXQuIEludHJvZHVjZWQgYW4KPiAgIElOVkFMSURfQUNUSVZFX1ZNSUQgd2hpY2ggaXMg
YmFzaWNhbGx5IGEgVk1JRCAwIHdpdGggZ2VuZXJhdGlvbiAxLgo+IMKgIFNpbmNlIHRoZSBiYXNp
YyBhbGxvY2F0b3IgYWxnb3JpdGhtIHJlc2VydmVzIHZtaWQgIzAsIGl0IGlzIG5ldmVyCj4gICB1
c2VkIGFzIGFuIGFjdGl2ZSBWTUlELiBUaGlzIChob3BlZnVsbHkpIHdpbGwgZml4IHRoZSBpc3N1
ZSBvZgo+ICAgdW5uZWNlc3NhcmlseSByZXNlcnZpbmcgVk1JRCBzcGFjZSB3aXRoIGFjdGl2ZV92
bWlkcyB3aGVuIHRob3NlCj4gICBWTXMgYXJlIG5vIGxvbmdlciBhY3RpdmVbMF0gYW5kIGF0IHRo
ZSBzYW1lIHRpbWUgYWRkcmVzcyB0aGUKPiAgIHByb2JsZW0gbm90ZWQgaW4gdjMgd2hlcmVpbiBl
dmVyeXRoaW5nIGVuZHMgdXAgaW4gc2xvdy1wYXRoWzFdLgo+IAo+IFsuLi5dCgpBcHBsaWVkIHRv
IG5leHQsIHRoYW5rcyEKClsxLzRdIEtWTTogYXJtNjQ6IEludHJvZHVjZSBhIG5ldyBWTUlEIGFs
bG9jYXRvciBmb3IgS1ZNCiAgICAgIGNvbW1pdDogNDE3ODM4MzkyZjJlNjU3ZWUyNWNjMzBlMzcz
ZmY0YzM1YTBmYWE5MApbMi80XSBLVk06IGFybTY0OiBNYWtlIFZNSUQgYml0cyBhY2Nlc3NpYmxl
IG91dHNpZGUgb2YgYWxsb2NhdG9yCiAgICAgIGNvbW1pdDogZjgwNTFlOTYwOTIyYTlkZThlNDIx
NTkxMDNkNWQ5YzY5N2VmMTdlYwpbMy80XSBLVk06IGFybTY0OiBBbGlnbiB0aGUgVk1JRCBhbGxv
Y2F0aW9uIHdpdGggdGhlIGFybTY0IEFTSUQKICAgICAgY29tbWl0OiAzMjQ4MTM2YjM2MzdlMTY3
MWU0ZmE0NmUzMmUyMTIyZjllYzRiYzNkCls0LzRdIEtWTTogYXJtNjQ6IE1ha2UgYWN0aXZlX3Zt
aWRzIGludmFsaWQgb24gdkNQVSBzY2hlZHVsZSBvdXQKICAgICAgY29tbWl0OiAxMDBiNGYwOTJm
ODc4ZGMzNzlmMWZjZWY5Y2U1NjdjMjVkZWUzNDczCgpDaGVlcnMsCgoJTS4KLS0gCldpdGhvdXQg
ZGV2aWF0aW9uIGZyb20gdGhlIG5vcm0sIHByb2dyZXNzIGlzIG5vdCBwb3NzaWJsZS4KCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
