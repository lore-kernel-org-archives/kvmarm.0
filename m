Return-Path: <SRS0=xLVY=HF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B42DC433DB
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 15:58:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B4DDA64F91
	for <kvmarm@archiver.kernel.org>; Wed,  3 Feb 2021 15:58:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4DDA64F91
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 21B0E4B282;
	Wed,  3 Feb 2021 10:58:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RwMPJkOIVsSj; Wed,  3 Feb 2021 10:58:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30DEB4B274;
	Wed,  3 Feb 2021 10:58:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D6C74B246
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 10:58:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gcWlAtb3YgYd for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Feb 2021 10:58:39 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 441BB4B241
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Feb 2021 10:58:39 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3128164F65;
 Wed,  3 Feb 2021 15:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612367918;
 bh=K59+ysyzksVMwJO4K3IQGFBLA+vh5P1R5hVr7mhTX0o=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=fM7SFqDXMg/QLD8TWNvrnoM5MjHuJjnK5+czbDxVPpQB7YFw6x0QPXxQ7Rxb8F1kR
 gVZZp6gb+Jnnox8hFopqCHQGf2p2xvojEklQbWbZVDwsS9KNh9l/WhH16A5O37/pIu
 vrfBENpdvL7uvuFTjd3v3R36n1YJC2wnpv4iENRHC/FHtn1RzpqEwqn5sqfT2HDK6k
 eo5sHlz4fLAbf6h9gS1f8+RvlLyKufY9XU8svoGJrDDSiQurtaNJJWJGCtF6GWZF7E
 4cLwALUvcsouJrBAYugYyQNh67aXO1q8FVVTQP9RvvOtaaYB2ROzch5Ww7Johcnn6/
 /P9PkrZVj2/Ww==
Date: Wed, 3 Feb 2021 15:58:32 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 23/26] KVM: arm64: Refactor __populate_fault_info()
Message-ID: <20210203155831.GG18974@willie-the-truck>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-24-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210108121524.656872-24-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Fri, Jan 08, 2021 at 12:15:21PM +0000, Quentin Perret wrote:
> Refactor __populate_fault_info() to introduce __get_fault_info() which
> will be used once the host is wrapped in a stage 2.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 36 +++++++++++++++----------
>  1 file changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 84473574c2e7..e9005255d639 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -157,19 +157,9 @@ static inline bool __translate_far_to_hpfar(u64 far, u64 *hpfar)
>  	return true;
>  }
>  
> -static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
> +static inline bool __get_fault_info(u64 esr, u64 *far, u64 *hpfar)

Could this take a pointer to a struct kvm_vcpu_fault_info instead?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
