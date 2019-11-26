Return-Path: <SRS0=sT9x=ZS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC17C432C0
	for <kvmarm@archiver.kernel.org>; Tue, 26 Nov 2019 21:04:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7B5F20835
	for <kvmarm@archiver.kernel.org>; Tue, 26 Nov 2019 21:04:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HGZn8gSy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7B5F20835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA61D4A5C3;
	Tue, 26 Nov 2019 16:04:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aUkgW08XYJCB; Tue, 26 Nov 2019 16:04:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C31914A830;
	Tue, 26 Nov 2019 16:04:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD4984A5C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Nov 2019 16:04:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zIE9mpsIOxel for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Nov 2019 16:04:20 -0500 (EST)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B0C1C4A5BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Nov 2019 16:04:20 -0500 (EST)
Received: by mail-wr1-f65.google.com with SMTP id b18so24137517wrj.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Nov 2019 13:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=VG2sMJBPHsAoU1EbZvezAk3PWquynbkCLDavk/F1YHo=;
 b=HGZn8gSyFXLXl2BVdGssmwXR8j7ZAp0UHP2iRsTIxjOiuONp0DFliudxAP2TgK/NKX
 uN6M2jbfQC7ohD8OqV0mQFWQMIoZ50MI6zjAC7ZApbU2PKKG6CMVsC0EC8nurX7a4rza
 wZD1YF68yJMkpE76hDef/RlPXiOii9k463cW0R1BQOfADH7SLZ2yc7QPcosc3H+xAI9V
 +qL+67TVWTDQ1kKyVI0zzVe0Fd0RkJH0vMQKEOUBvD6HHs9Tkrp1WMrKkDQVjzw6/zpQ
 Xc4D0yKf7nod2C55O8lXm4ah6uCciLbAIpV4ENnowBFOjodlBS0nhT22tB7AceAa1P3M
 XMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=VG2sMJBPHsAoU1EbZvezAk3PWquynbkCLDavk/F1YHo=;
 b=XgVFYZyRE9mjDYGouBFU/lbWmmn8rlvPQ+9faN6I9bS6MnAcNRJdFiKU8cWWMOrgLs
 mhly5bJN2tprUEumJq2M02WA/8wuKP5MJIYZ+qL5nOcBwIQcODJwLZeAxYVAiTdl++jX
 mE8DMRrijWVd7wYIMa2qRo7Y7rfCr5HtXnv/yBJEuH0AlWkkbuj9SvSEVPa9m4wQhgYb
 jmrr8zaNvxrJ8r+IgfxZrCcQ0r4j5cvibKd9VCKJbFarZvYlLTpkwCb6ESBsB7Fg50vt
 K4abGODdzAVfpLIX37ZQyn+/hCX28tCyipkb9/E/Pbu3wixKeD9IZGNkE6+mNucs3+EB
 ptag==
X-Gm-Message-State: APjAAAUbs85kPuJ8FJodByNQ0rMFXtqQB+p4sns+T1N8IRk0Cef9uoSi
 8SFC+QlYCUD1S3wyYB/F1YAOT9nRWCCr+g==
X-Google-Smtp-Source: APXvYqy/Yqa8VJhKBH3hw7SPfLL6si1o4j+uigjdVcBxp0SKi21vOlr8cF8QsNxXJ70EgtKFLN9+jQ==
X-Received: by 2002:adf:eb42:: with SMTP id u2mr21407807wrn.173.1574802259359; 
 Tue, 26 Nov 2019 13:04:19 -0800 (PST)
Received: from [192.168.1.136] ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id v9sm15285628wrs.95.2019.11.26.13.04.18
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 26 Nov 2019 13:04:18 -0800 (PST)
Subject: Re: [PATCH] target/arm: Honor HCR_EL2.TID3 trapping requirements
To: Marc Zyngier <maz@kernel.org>, qemu-devel@nongnu.org
References: <20191123115618.29230-1-maz@kernel.org>
From: Richard Henderson <richard.henderson@linaro.org>
Openpgp: preference=signencrypt
Message-ID: <11f7be55-a53d-bab1-c2e6-edbca1abb554@linaro.org>
Date: Tue, 26 Nov 2019 21:04:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191123115618.29230-1-maz@kernel.org>
Content-Language: en-US
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On 11/23/19 11:56 AM, Marc Zyngier wrote:
> HCR_EL2.TID3 mandates that access from EL1 to a long list of id
> registers traps to EL2, and QEMU has so far ignored this requirement.
> 
> This breaks (among other things) KVM guests that have PtrAuth enabled,
> while the hypervisor doesn't want to expose the feature to its guest.
> To achieve this, KVM traps the ID registers (ID_AA64ISAR1_EL1 in this
> case), and masks out the unsupported feature.
> 
> QEMU not honoring the trap request means that the guest observes
> that the feature is present in the HW, starts using it, and dies
> a horrible death when KVM injects an UNDEF, because the feature
> *really* isn't supported.
> 
> Do the right thing by trapping to EL2 if HCR_EL2.TID3 is set.
> 
> Reported-by: Will Deacon <will@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> There is a number of other trap bits missing (TID[0-2], for example),
> but this at least gets a mainline Linux going with cpu=max.

BTW, Peter, this appears to have been the bug that was causing me so many
problems on my VHE branch.  Probably *exactly* this bug wrt ptrauth, since that
would also be included with -cpu max.

I am now able to boot a kvm guest kernel to the point of the no rootfs panic,
which I wasn't before.

I can only think that I mis-identified the true cause in Lyon.

Anyway, thanks Marc!


r~
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
