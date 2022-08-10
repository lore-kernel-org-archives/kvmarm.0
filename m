Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78060C00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 09:08:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDFF94D6EC;
	Wed, 10 Aug 2022 05:08:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RQzk66vL0T1x; Wed, 10 Aug 2022 05:08:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADC674D6F4;
	Wed, 10 Aug 2022 05:08:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A36A74D6EC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 05:08:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pwd2VEO+UQ3c for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 05:08:19 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 525524D6EA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 05:08:19 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id ECD9261072;
 Wed, 10 Aug 2022 09:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A596C433D7;
 Wed, 10 Aug 2022 09:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1660122497;
 bh=fnXaYwu3upLYBGaCBhQVJsI6d8huckYTIO7QAKu6jbw=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=YzqWJvJljaFP+0uMFd6W7GvVRh+qxWz5GANjJX6mGnttSqImwNuSFc3PgYyc8x7i1
 x9ZurvdkivxUh1CGzMHoxlATklGYYuFeK9uvrlzNjjn4jarVnppp2Js/TAezDVrqBF
 M0jeIrimVCAwmF/tfqu/8hXguXVl2CRgc9X+EtmimwVhWgpAsjGrTuBGneOdtmiqlL
 ljD+kBpAqL2Bih/bQkrk9Ur38XgBBT0rPJ1Dse10CT2u3MHaEjG7HRat0e0H9hDO96
 z+5pghP0Iu2HjlXgnZM3opdGcm4oLPAqK1Mlzp3L0TdPSf8lrJBGkfnucqEsLQzq/K
 7SoqgfXU7UQ8g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oLhhH-0025nz-07;
 Wed, 10 Aug 2022 10:08:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Yang Yingliang <yangyingliang@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: arm64: fix compile error because of shift overflow
Date: Wed, 10 Aug 2022 10:08:10 +0100
Message-Id: <166012247956.2742754.12984698031789785989.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220810013435.1525363-1-yangyingliang@huawei.com>
References: <20220810013435.1525363-1-yangyingliang@huawei.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, yangyingliang@huawei.com,
 linux-kernel@vger.kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 james.morse@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

T24gV2VkLCAxMCBBdWcgMjAyMiAwOTozNDozNSArMDgwMCwgWWFuZyBZaW5nbGlhbmcgd3JvdGU6
Cj4gVXNpbmcgR0VOTUFTSygpIHRvIGdlbmVyYXRlIHRoZSBtYXNrcyBvZiBkZXZpY2UgdHlwZSBh
bmQgZGV2aWNlIGlkLCBpdCBtYWtlcwo+IGNvZGUgdW5hbWJpZ3VvdXMsIGFsc28gaXQgY2FuIGZp
eCB0aGUgZm9sbG93aW5nIGZpeCBjb21waWxlIGVycm9yIGJlY2F1c2Ugb2YKPiBzaGlmdCBvdmVy
ZmxvdyB3aGVuIHVzaW5nIGxvdyB2ZXJpc29uIGdjYyhtaW5lIHZlcnNpb24gaXMgNy41KToKPiAK
PiBJbiBmdW5jdGlvbiDigJhrdm1fdm1faW9jdGxfc2V0X2RldmljZV9hZGRyLmlzcmEuMzjigJks
Cj4gICAgIGlubGluZWQgZnJvbSDigJhrdm1fYXJjaF92bV9pb2N0bOKAmSBhdCBhcmNoL2FybTY0
L2t2bS9hcm0uYzoxNDU0OjEwOgo+IC4vLi9pbmNsdWRlL2xpbnV4L2NvbXBpbGVyX3R5cGVzLmg6
MzU0OjM4OiBlcnJvcjogY2FsbCB0byDigJhfX2NvbXBpbGV0aW1lX2Fzc2VydF81OTnigJkgXAo+
IGRlY2xhcmVkIHdpdGggYXR0cmlidXRlIGVycm9yOiBGSUVMRF9HRVQ6IG1hc2sgaXMgbm90IGNv
bnN0YW50Cj4gICBfY29tcGlsZXRpbWVfYXNzZXJ0KGNvbmRpdGlvbiwgbXNnLCBfX2NvbXBpbGV0
aW1lX2Fzc2VydF8sIF9fQ09VTlRFUl9fKQoKQXBwbGllZCB0byBmaXhlcywgdGhhbmtzIQoKWzEv
MV0gS1ZNOiBhcm02NDogZml4IGNvbXBpbGUgZXJyb3IgYmVjYXVzZSBvZiBzaGlmdCBvdmVyZmxv
dwogICAgICBjb21taXQ6IGFlM2IxZGE5NTQxMzYxNGY5NmZmYTIzZDIwMDkyOWM2ZjgwOWM4MDcK
CkNoZWVycywKCglNLgotLSAKTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxp
c3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlh
LmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
