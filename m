Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD94C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 18 Jan 2022 17:18:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4763049F03;
	Tue, 18 Jan 2022 12:18:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kAsCdwvSsO+G; Tue, 18 Jan 2022 12:18:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B21749F09;
	Tue, 18 Jan 2022 12:18:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9617F49F03
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 12:18:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X045HLFMGhNS for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jan 2022 12:18:09 -0500 (EST)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
 [209.85.128.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C6D44141D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 12:18:09 -0500 (EST)
Received: by mail-wm1-f44.google.com with SMTP id c66so29252468wma.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 09:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Q22wl6OCD19GypMuT9QWRHowipst+oy+Pq7cX65GDBI=;
 b=XUFayqN3S6FO4rPKr8roe5K/9ilHZSe4lyDj0PGBjfxYK5UPUK9yVoOP1cuzZi4978
 EL7ELnSrMVQtL1DugrfPVtAtJSIY9W+fs7/RXfkHB2QzccKaNTJw8Quj6AapJKw7kBCy
 zZ+HMyYgZvn9L1V9WWHUmuzT0IOQLDQJqJbGehtZvALfgf8Ff/QezpFCPRx7KvGTEUH6
 G8cfFfn2dpLENFi+QttOleeMdDgK8352iOb30OOWBVbWR4NbhjndWOglswuUnm5+5zw1
 J8KquigKXGiv3hUXXABfzkZgl4Gx9eJG63UzqSQX9HEQrxdrwRGhEI0yrIoK/Eh4r+E7
 p9Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Q22wl6OCD19GypMuT9QWRHowipst+oy+Pq7cX65GDBI=;
 b=BPJbB72ir6VPKQ1BWwM1S/4cbt596u328hS9fOtLC9R5wQzDNipfrC2f76kFR/Gj/1
 U5YbxZHmbwPZPiByOSeK7i6zgVbwUDvLJeWgqIEhBBI+AUZVYj1KCOXv+AiCZ5XMEeG3
 TIlOcgFGeg4uDLYbXu/V6qqMXp+iDr5pr6hCd3RZ8DA8zcTiuCoiBGRDVZ1kQjF9QNuv
 CwIIA19z0dwfC1Qmv0/2aTuoyP9xSoyg45WcibNHpiEht2HI4k6hrxOcovdEHPQtx588
 ii/sXi2CnG97/xM4StTwuE+Ynit0x8+9A7dpIVYAif2MIn6WRIBt30sl0fvYVKCikfuQ
 nDYA==
X-Gm-Message-State: AOAM532YR5w/iamvOP0g3FSBK6nlkL3wRFUkqycNTQOvrLdm9njzOW1o
 cwZ80ID1/gKpc2q4Bp6IwdV6x4pyAoImPfTjmOVsRg==
X-Google-Smtp-Source: ABdhPJz8MsvFIKOMo3v6OXCZ/Gti1AwvjDfQH2v2OENrYDIXl+aE+R5HUBYG9wft9NNF4CAYxEC9y6k8jNSNNSoXMnQ=
X-Received: by 2002:a05:600c:4f51:: with SMTP id
 m17mr11463648wmq.32.1642526288443; 
 Tue, 18 Jan 2022 09:18:08 -0800 (PST)
MIME-Version: 1.0
References: <20220114140741.1358263-1-maz@kernel.org>
In-Reply-To: <20220114140741.1358263-1-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 18 Jan 2022 17:17:57 +0000
Message-ID: <CAFEAcA9dFVUY5a9WANrS1UEPrbsUueYaUzneMYhjdn=XTKDGvA@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] target/arm: Reduced-IPA space and highmem fixes
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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

On Fri, 14 Jan 2022 at 14:08, Marc Zyngier <maz@kernel.org> wrote:
>
> Here's yet another stab at enabling QEMU on systems with
> pathologically reduced IPA ranges such as the Apple M1 (previous
> version at [1]). Eventually, we're able to run a KVM guest with more
> than just 3GB of RAM on a system with a 36bit IPA space, and at most
> 123 vCPUs.
>
> This also addresses some pathological QEMU behaviours, where the
> highmem property is used as a flag allowing exposure of devices that
> can't possibly fit in the PA space of the VM, resulting in a guest
> failure.
>
> In the end, we generalise the notion of PA space when exposing
> individual devices in the expanded memory map, and treat highmem as
> another flavour of PA space restriction.



Applied to target-arm.next, thanks.

-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
