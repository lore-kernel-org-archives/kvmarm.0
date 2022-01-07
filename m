Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26910C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jan 2022 18:48:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86EFE4B279;
	Fri,  7 Jan 2022 13:48:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qwUjIYCMEZrn; Fri,  7 Jan 2022 13:48:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 611D14B1E9;
	Fri,  7 Jan 2022 13:48:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A7114B1E9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 13:48:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OscosUkCXPrP for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jan 2022 13:48:28 -0500 (EST)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 240834B1E1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 13:48:28 -0500 (EST)
Received: by mail-wr1-f45.google.com with SMTP id l25so1906742wrb.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Jan 2022 10:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=raftlsgfS0DQzuOTvWNeZTfeD+RimU34KWwkH9tPzXs=;
 b=NbTWi5M8MEUi0BMTcfYbnzqyj+f5aYFWoCxMXQurA9exrgDjgLVAbGS+vN0aZiDYI+
 1IRQc1VOo4NukUiZql4qunI9YKvTBUesEeqQkYh01nkestt8s8wPyNhE4B9UuBq652zj
 6mBQaM4bY+JlzD0ZwhnawuXxUVaJllVSTx2bNHQXbszLB2O1wiy0Qzi6tHOTxL/kUdbt
 1ZQNNfqV8ePvLwNVxEBZ0kzLTz1varW700B07QaJCeUTv64LmtUvragToRP5fvHeSan9
 0opvPRk+00khMAQRIRzwT7qQjZfPRz+Wc4QM5UUsXWMtSEvV+uf9Ws7IWSrkQhZjtFJB
 0W5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=raftlsgfS0DQzuOTvWNeZTfeD+RimU34KWwkH9tPzXs=;
 b=kX+iYU51QBWe7Cy8ssHLGoqUZp2erebGPvgMsTQqZmVx3DYVYlUaFLqyq1ovppaBNu
 J2gQSLTg0/v08a8HclI4Ga7GkMopjoGt4QH7eNQyJ6Fzv3910TPff/rema/HtI5tgsNP
 ApiqY6D7orSp4THN5u5S7fB9hnNDJlyNBAVHP8mrpiYX7xKrGvLaycNmuPoHb6/EVeL5
 2i2u3zFtmyFQ7M5+UpmfPUfoQhDrMDyswoU8LxrLt8S1PvlAdPQQFsnqeTZ0PY1S4lub
 QgzGpnc7d1cjfF6KyauyOeFO2rS+2TUrLKlLudXRSyEXnMYF0xsEGPBcyrKt+Y8k16dW
 yKLg==
X-Gm-Message-State: AOAM532XXTkGohEyCn1IXywC7tgp55uRqqknqNgootcgXO/DOoLkFbhU
 xvawIws/FWDctPEz9XR3jF6+4WEVICwz09JwZahCDA==
X-Google-Smtp-Source: ABdhPJxSrCyrEJr1EOWUT8XHqQX7+3cJ1ZfTXpm2LDTyfxkzeXIDtwiHj6P1/dInVJ97Wnu5CZ4/oDt3wl8O0HKcwDM=
X-Received: by 2002:a5d:52c4:: with SMTP id r4mr34251380wrv.521.1641581307149; 
 Fri, 07 Jan 2022 10:48:27 -0800 (PST)
MIME-Version: 1.0
References: <20211227211642.994461-1-maz@kernel.org>
 <20211227211642.994461-4-maz@kernel.org>
 <ef8b3500-04ab-5434-6a04-0e8b1dcc65d1@redhat.com>
 <871r1kzhbp.wl-maz@kernel.org>
 <d330de15-b452-1f9c-14fa-906b88a8b4c4@redhat.com>
 <87y23rtnny.wl-maz@kernel.org>
In-Reply-To: <87y23rtnny.wl-maz@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 7 Jan 2022 18:48:16 +0000
Message-ID: <CAFEAcA8KCZFfiYA_AAxA-ChfN5vZd7EF1jGcFxmcpq=fi4ToeQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] hw/arm/virt: Honor highmem setting when computing
 the memory map
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

On Fri, 7 Jan 2022 at 18:18, Marc Zyngier <maz@kernel.org> wrote:
> This is a chicken and egg problem: you need the IPA size to compute
> the memory map, and you need the memory map to compute the IPA
> size. Fun, isn't it?
>
> At the moment, virt_set_memmap() doesn't know about the IPA space,
> generates a highest_gpa that may not work, and we end-up failing
> because the resulting VM type is out of bound.
>
> My solution to that is to feed the *maximum* IPA size to
> virt_set_memmap(), compute the memory map there, and then use
> highest_gpa to compute the actual IPA size that is used to create the
> VM. By knowing the IPA limit in virt_set_memmap(), I'm able to keep it
> in check and avoid generating an unusable memory map.

Is there any reason not to just always create the VM with the
maximum supported IPA size, rather than trying to create it
with the smallest IPA size that will work? (ie skip the last
step of computing the IPA size to create the VM with)

-- PMM
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
