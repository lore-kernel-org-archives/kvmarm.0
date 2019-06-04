Return-Path: <SRS0=jSi8=UD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2422C282CE
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 09:32:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 45F5520645
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 09:32:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jxJdMBDI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 45F5520645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2C0F4A4EC;
	Tue,  4 Jun 2019 05:32:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tedLWtwePr+u; Tue,  4 Jun 2019 05:31:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A6264A483;
	Tue,  4 Jun 2019 05:31:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88D3D4A417
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 05:31:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a2+LalfCW+wG for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jun 2019 05:31:57 -0400 (EDT)
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com
 [209.85.215.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7FC654A3BF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 05:31:57 -0400 (EDT)
Received: by mail-pg1-f193.google.com with SMTP id a3so2618713pgb.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Jun 2019 02:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=MimY8E6RzMP+Xm09/RStVcP0kJblyDIRLMNiKjGKR1U=;
 b=jxJdMBDIJRCbNIZuMnUELhdpEn41VADNgzlplcmAXJynP+m5d5YB4HbguZiv5hotqh
 l9w0GY8FrukKhQunBoGC3tAk0TlFur1DY+UTBOFMtEibcehQBzR0/478UnelnBdK/V6A
 civ0aWuPhTj2Lwrl6dlU8QQhiKIrTdiBTJx5LpmBsvNbpvea8RzLiWd+RM62SI1//lOZ
 yUk4JVITz3zKEWBmVqO8Y91afvJI7gLRH7sNlStVxUs/iSwo5FYEqRV3GrEhSEkLmf7U
 pI79hFjf/o2dlic8f0PYj/PwMYEMLQwYNb+R9/B1m1R3PcNiX5lysTh/prELjaTBLH7G
 7OvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=MimY8E6RzMP+Xm09/RStVcP0kJblyDIRLMNiKjGKR1U=;
 b=KHrFWLiqcSSZvyQanHsi1RTzAO/L/VahzaScNRbwxNY2vscuvBuDrBOHYWGjERRj/b
 LKa6X4dE0YorGrYrhE7TUiNWHO8EXry5Fkp76Den3wVG/nGxy1xi4LWyrdcOvtJhHyZ2
 szbqe3ZAVx8AFYifr434sSI3862Ze9SMz8gBK5QoGB3BmuZwfC18cGDKCcOjrngbFIb5
 fQhfbFfBF8s5c/pyG4JdS5iWARepQECQhTCfepzzCD7YEyRN6xYIn/OC8VD40iCiCj5d
 4bfBkrdoQq/nmNsSWSXSAXcIEblHjkYxuEZt/QD/ugJHGePbqADVmtC3zZDTLeu6W3ZF
 1KAQ==
X-Gm-Message-State: APjAAAVyHUGGGjDBwhwb0iKuqG6mJCRrgXdQr44859YhaP4DPZKHacAP
 yJ14QE+nH+kJpkUBoSgS6uoEZA==
X-Google-Smtp-Source: APXvYqzkBCd15WCdDavN2+OthVD2LAb86dzXlH0Ye+ZreCxe0UdK/8MuhKMRME3oQVp6Fs1Cw+s2oQ==
X-Received: by 2002:aa7:92da:: with SMTP id k26mr36714866pfa.70.1559640716355; 
 Tue, 04 Jun 2019 02:31:56 -0700 (PDT)
Received: from localhost ([122.172.66.84])
 by smtp.gmail.com with ESMTPSA id b16sm17600287pfd.12.2019.06.04.02.31.55
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 04 Jun 2019 02:31:55 -0700 (PDT)
Date: Tue, 4 Jun 2019 15:01:53 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH] KVM: arm64: Drop 'const' from argument of vq_present()
Message-ID: <20190604093153.2pzv55knl6axugrv@vireshk-i7>
References: <699121e5c938c6f4b7b14a7e2648fa15af590a4a.1559623368.git.viresh.kumar@linaro.org>
 <20190604084349.prnnvjvjaeuhsmgs@mbp>
 <20190604085545.hsmxfqkpt2cbrhtw@vireshk-i7>
 <20190604092639.GS28398@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190604092639.GS28398@e103592.cambridge.arm.com>
User-Agent: NeoMutt/20180716-391-311a52
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
 Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
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

On 04-06-19, 10:26, Dave Martin wrote:
> I'm in two minds about whether this is worth fixing, but if you want to
> post a patch to remove the extra const (or convert vq_present() to a
> macro), I'll take a look at it.

This patch already does what you are asking for (remove the extra
const), isn't it ?

I looked at my textbook (The C programming Language, By Brian W.
Kernighan and Dennis M. Ritchie.) and it says:

"
The const declaration can also be used with array arguments, to
indicate that the function does not change that array:

int strlen(const char[]);
"

and so this patch isn't necessary for sure.

-- 
viresh
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
