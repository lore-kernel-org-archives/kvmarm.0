Return-Path: <SRS0=/Ra0=HH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE94C433DB
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 09:51:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6AB8064E49
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 09:51:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6AB8064E49
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FF4F4B381;
	Fri,  5 Feb 2021 04:51:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Teq6KON1SG6r; Fri,  5 Feb 2021 04:51:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BE114B386;
	Fri,  5 Feb 2021 04:51:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A57154B36D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 04:51:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MQ--JvEueFLb for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2021 04:51:34 -0500 (EST)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0F8C4B380
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 04:51:34 -0500 (EST)
Received: by mail-wm1-f49.google.com with SMTP id f16so5456647wmq.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 Feb 2021 01:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=VjKGmSN62P3b8Gz6m1qtw9F99Y61/6CwerUG3tU7MY4=;
 b=hWd/h67FoDG08zJsdEf7THf5fsb8v5CDM+WHa00/AqDgZTi/FJ+XGDpt9noS8j92eT
 c1yHqJWnhx8pzofgcTkG621MIs+ZYNlzfNozMBJ4JGCLPQtNYcZpfLKnYu5xL/x6BT71
 aEdAxyGZOr6ngMqNl+eTVJ0vkLcZMUIAF37j+R6ukekbSONzz5ikB96WW1ggQpbmjh4e
 pzHSlO7VExl5U8GM7ducj2019BOduKzXoVXs1I8Eb0OZbXXoEFER+3Mi9BFjFmjfFpH9
 0gGWV1VKYh/xeHfSCvsqZuEIO8leB844woCNQpyIv7/edOIt3pyLFA5cl+hc11LUi2l0
 BUGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=VjKGmSN62P3b8Gz6m1qtw9F99Y61/6CwerUG3tU7MY4=;
 b=T0YClAiIQ8b/k8jCTdYARVqdtiWmtqUge1tgbi+5UCBVU9L/GIs53u1iY12weFHXcr
 IJ5Y5Cr1bhjOek8hx7E4ySw6nH4lymrFggR2H6P3eiwGm+rZ+li1qOTk64/+yzYvN7tI
 ZZrEISljPDu35j9pr19fmWfuEvlxBCMBsK244ZZJ19ZWRuErzr6Iqn64nSfGOK7XNx1P
 bPnz2OR1mV6t8Kdt6ffbbN5HiWuC+9JmHUtHrlV57rjG4zaIhP2Yd7yTsbIqlw9A+6n9
 w1ewocoeJfrAf/ULt9wQ7V59SefYARSJtKmXG/lRshqTmlhoIROkqG3l3tJixqFeyUrL
 K4IQ==
X-Gm-Message-State: AOAM530Ez+bBdfOVF1yPkR5az4ByRDfybM8W6zWe8ysV8GLXojENl7za
 x4gLQ4j5RKy04j4+j/ExiluNFw==
X-Google-Smtp-Source: ABdhPJyBpgLCQ/JhIkBboD0wFrqF+LmtaNQmOXy+bUTKCu4KXYd0D+Ym0BJGOgt45t7ajfN+ikeD0w==
X-Received: by 2002:a1c:7d0c:: with SMTP id y12mr2849282wmc.184.1612518693792; 
 Fri, 05 Feb 2021 01:51:33 -0800 (PST)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
 by smtp.gmail.com with ESMTPSA id m18sm11669198wrx.17.2021.02.05.01.51.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 05 Feb 2021 01:51:33 -0800 (PST)
Date: Fri, 5 Feb 2021 10:51:14 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [RFC PATCH 01/11] iommu/arm-smmu-v3: Add feature detection for
 HTTU
Message-ID: <YB0VErwkA0ivRXTd@myrica>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-2-zhukeqian1@huawei.com>
 <f8be5718-d4d9-0565-eaf0-b5a128897d15@arm.com>
 <df1b8fb2-b853-e797-0072-9dbdffc4ff67@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <df1b8fb2-b853-e797-0072-9dbdffc4ff67@huawei.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>, Cornelia Huck <cohuck@redhat.com>,
 Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, lushenming@huawei.com,
 linux-kernel@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
 Catalin Marinas <catalin.marinas@arm.com>, iommu@lists.linux-foundation.org,
 Marc Zyngier <maz@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Keqian,

On Fri, Feb 05, 2021 at 05:13:50PM +0800, Keqian Zhu wrote:
> > We need to accommodate the firmware override as well if we need this to be meaningful. Jean-Philippe is already carrying a suitable patch in the SVA stack[1].
> Robin, Thanks for pointing it out.
> 
> Jean, I see that the IORT HTTU flag overrides the hardware register info unconditionally. I have some concern about it:
> 
> If the override flag has HTTU but hardware doesn't support it, then driver will use this feature but receive access fault or permission fault from SMMU unexpectedly.
> 1) If IOPF is not supported, then kernel can not work normally.
> 2) If IOPF is supported, kernel will perform useless actions, such as HTTU based dma dirty tracking (this series).
> 
> As the IORT spec doesn't give an explicit explanation for HTTU override, can we comprehend it as a mask for HTTU related hardware register?

To me "Overrides the value of SMMU_IDR0.HTTU" is clear enough: disregard
the value of SMMU_IDR0.HTTU and use the one specified by IORT instead. And
that's both ways, since there is no validity mask for the IORT value: if
there is an IORT table, always ignore SMMU_IDR0.HTTU.

That's how the SMMU driver implements the COHACC bit, which has the same
wording in IORT. So I think we should implement HTTU the same way.

One complication is that there is no equivalent override for device tree.
I think it can be added later if necessary, because unlike IORT it can be
tri state (property not present, overriden positive, overridden negative).

Thanks,
Jean

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
