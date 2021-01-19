Return-Path: <SRS0=GHi4=GW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DA4C433E9
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jan 2021 13:17:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7B55A2312D
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jan 2021 13:17:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B55A2312D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C017C4B2D8;
	Tue, 19 Jan 2021 08:17:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1qK7qSIp3hWR; Tue, 19 Jan 2021 08:17:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB2754B29F;
	Tue, 19 Jan 2021 08:17:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 993494B275
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jan 2021 08:17:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WcltBuI4gdyJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jan 2021 08:17:42 -0500 (EST)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com
 [209.85.208.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5CAFF4B26A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jan 2021 08:17:42 -0500 (EST)
Received: by mail-lj1-f169.google.com with SMTP id u21so21899698lja.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jan 2021 05:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=V0WyZ0QjeeZxPEOPKkoltDAJRX7zc5vT1YGzpNcNLdg=;
 b=LOKDOAdbletZJxnT+nSaBkOgX3NZbBgWpZRAbqYlUul6ZCkyKN8zA/ia6Ds6vE5yoj
 rjts812XBS1aFJraX8QRugBXIJEBGr4LGwdRH+jybZVowZvtW78kbI7rfTy96mMLSrjK
 W3Y8Ev5DiFpdt/ZkLfMvVp5uAUaXzntEN1Q1i/pJCmp9HjUntST5omCO4tP+jC4hqdG/
 xCHgoSSBEZu8vp+rszoxN06cH5TsSSI3sTfNeWTZpZcFVz83GQi02J6w6uamqUKyFu+U
 XlMupOFR8JDQmhHkZxcEo2OyGgaqizv6soDyTUexM9eL7n9wxRl9WWti86pE3KwXvcde
 8R1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=V0WyZ0QjeeZxPEOPKkoltDAJRX7zc5vT1YGzpNcNLdg=;
 b=kPH7BW+PnXsRh0KvQnEEjH76qSWoSHa8OX+SmEIoWYv2hA41ztP1j8MF7ZUOGO6VYq
 79UfAIVKNoSW70SkuW/Q14ZZVTbwWi/WapxDvMsjT4XOFN1zUZdBPZXv81llZ646FZFW
 z4hmVhmn70hEZgyPsOw8coqG18SCqc6ZyhYAOybAHDEwWJ9oMJkkVdNG/V0Hw/h37KCO
 jSnoNWlMnj4TL21DPn+ZzaNowYAW2SJVtssxKY6gmKTsEo/5JoR4LwVJzqF/ByWXKRTz
 8NY9Y+I1C5LHiSp+X/By2qhylMHMzKwDFE4wq16qyU7NzDM1Qy/jGFwbJNN6pyHCk8Dk
 p3Bw==
X-Gm-Message-State: AOAM533hx4zIubsBM5cgesvBTur3g4KkUnMYz93fN/4nJkFKNnJtcWhw
 wl2edMuwookYoun6PW4TK/R+/SzQSpv9YB+ogTU=
X-Google-Smtp-Source: ABdhPJxQLFCiId4xaE1FKf4J06dsRKMnZPjV3ri61od/WV6lWyDqFZBH6nkjkiiP7QKazbjZWcJthNp/sVBpsj2S7Fg=
X-Received: by 2002:a2e:90c8:: with SMTP id o8mr484635ljg.43.1611062260956;
 Tue, 19 Jan 2021 05:17:40 -0800 (PST)
MIME-Version: 1.0
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201110101542.GA17572@infradead.org>
 <b174c468e3df6dc7874b9ab886b38009@kernel.org>
In-Reply-To: <b174c468e3df6dc7874b9ab886b38009@kernel.org>
From: Janne Karhunen <janne.karhunen@gmail.com>
Date: Tue, 19 Jan 2021 15:17:29 +0200
Message-ID: <CAE=NcraN8NcnJEneno=U6dPj3esHSjChfqu9XKLNPE49ULhxwQ@mail.gmail.com>
Subject: Re: [PATCH v1 00/24] Opt-in always-on nVHE hypervisor
To: Marc Zyngier <maz@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, kernel-team@android.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Christoph Lameter <cl@linux.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

On Tue, Nov 10, 2020 at 1:19 PM Marc Zyngier <maz@kernel.org> wrote:

> > Why?  I thought we were trying to kill nVHE off now that newer CPUs
> > provide the saner virtualization extensions?
>
> We can't kill nVHE at all, because that is the only game in town.
> You can't even buy a decent machine with VHE, no matter how much money
> you put on the table.

As I mentioned it earlier, we did this type of nVHE hypervisor and the
proof of concept is here:
https://github.com/jkrh/kvms

See the README. It runs successfully on multiple pieces of arm64
hardware and provides a tiny QEMU based development environment via
the makefiles for the QEMU 'max' CPU. The code is rough, the amount of
man hours put to it is not sky high, but it does run. I'll update a
new kernel patch to patches/ dir for one of the later kernels
hopefully next week, up to now we have only supported kernels between
4.9 .... 5.6 as this is what our development hardware(s) run with. It
requires a handful of hooks in the kvm code, but the actual kvm calls
are just rerouted back to the kernel symbols. This way the hypervisor
itself can be kept very tiny.

The s2 page tables are fully owned by the hyp and the guests are
unmapped from the host memory when configured with the option (we call
it host blinding). Multiple VMs can be run without pinning them into
the memory.  It also provides a tiny out of tree driver prototype stub
to protect the critical sections of the kernel memory beyond the
kernel's own reach. There are still holes in the implementation such
as the virtio-mapback handling via whitelisting and paging integrity
checks, and many things are not quite all the way there yet. One step
at a time.


--
Janne
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
