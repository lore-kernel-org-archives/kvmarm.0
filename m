Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 018B5C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 08:45:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 863904B297;
	Fri, 17 Jun 2022 04:45:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JfzyruePplDQ; Fri, 17 Jun 2022 04:45:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79DAD4B1A2;
	Fri, 17 Jun 2022 04:45:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34A3B4B1C6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 04:45:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1Rp9w680+tuv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 04:45:53 -0400 (EDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com
 [209.85.208.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14FF94A3A5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 04:45:53 -0400 (EDT)
Received: by mail-ed1-f46.google.com with SMTP id o10so5280522edi.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 01:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=KL12GUSIFsOr7y2Ew6vSfP//iAGJZNB8vXdWl9WySdg=;
 b=VKQcrgU1e/BuoJL3/E/5xdtZZtAX+n2mc7kyaVWi3ECp3tVOj0Vfu9FYpaut/duuSz
 6quk8RAdcinthu3Op0BiyogjCOBrkHsN7yA4pBImVsGaob+usMkV4F2bfriOC70/7j4p
 wXf1+6FMMtVbDDJOqQtwFZdclvB6hK494nGqIqbmuAQ5NmsngkmxOYw5sSdo6GZ0PaCv
 WTdiqDsZoDvqzeHRbs+97VwWR+VjfoYaPbM1zixz13z1OTd/D0m87M1VQe3D5PLkADjA
 OX3MaZP/ie9tSfd5/r6LCVfr/CnVpU71Du8UqovEDC/LUMpUaoI0m2UpLe+5b8tieE9V
 WJ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=KL12GUSIFsOr7y2Ew6vSfP//iAGJZNB8vXdWl9WySdg=;
 b=oToGoqbZ/SWnG6IFfGiW4X8D+yBwDAhGj8K1+u9r6iAyEFRzSA5zY8winCbx+2llxZ
 YtPuD7To1jVWHMVmzs3qgtwKcIv3SHYeGnaWTwCQhpFaXcUi1y/TsqGhy3nyYC7JYVKs
 mVY0twfKXClf2EP9bkxEmPUeZ9mzIg6UhnQ5YFWbohzG+hT6sT9MFkpo6bdG4tBU84zz
 SMIGEY+rmNIwN/9/DNomDjTjikq7N0XFUdhDAamcYbPno+hx3hCBSbyKsPmfey2vxJ4b
 kmYZyKggs1Hk47iz76dKms6lF1JaBsx587369pyziR6TpGnzhXvrqVxZ2HfjaTJEOMgX
 lfFQ==
X-Gm-Message-State: AJIora9pFi/M/Nc3vbnDAfWto/reEQvBjIz3JvYbcsR4VdRKLpFk80OB
 3Ej6kIuCJrnVX3VAfuVzDU6bqw==
X-Google-Smtp-Source: AGRyM1v74Y86WCSwTs0mbpz8Uzc1XzusOKJp8Iwa3L1KmKQVX66F7ytavdX7JhAvnMDW75wpmw8weA==
X-Received: by 2002:a05:6402:2687:b0:430:328f:e46b with SMTP id
 w7-20020a056402268700b00430328fe46bmr10949958edd.33.1655455551764; 
 Fri, 17 Jun 2022 01:45:51 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com.
 [34.90.227.64]) by smtp.gmail.com with ESMTPSA id
 g8-20020a170906538800b006ff05d4726esm1888657ejo.50.2022.06.17.01.45.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 01:45:51 -0700 (PDT)
Date: Fri, 17 Jun 2022 08:45:48 +0000
From: Quentin Perret <qperret@google.com>
To: Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Prevent kmemleak from accessing pKVM memory
Message-ID: <Yqw/PI6jF5HZTvxB@google.com>
References: <20220616161135.3997786-1-qperret@google.com>
 <165545408679.771055.5076080259874437048.b4-ty@kernel.org>
 <Yqw9dou3qgpAKQkZ@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yqw9dou3qgpAKQkZ@kernel.org>
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Friday 17 Jun 2022 at 11:38:14 (+0300), Mike Rapoport wrote:
> On Fri, Jun 17, 2022 at 09:21:31AM +0100, Marc Zyngier wrote:
> > On Thu, 16 Jun 2022 16:11:34 +0000, Quentin Perret wrote:
> > > Commit a7259df76702 ("memblock: make memblock_find_in_range method
> > > private") changed the API using which memory is reserved for the pKVM
> > > hypervisor. However, it seems that memblock_phys_alloc() differs
> > > from the original API in terms of kmemleak semantics -- the old one
> > > excluded the reserved regions from kmemleak scans when the new one
> > > doesn't seem to. Unfortunately, when protected KVM is enabled, all
> > > kernel accesses to pKVM-private memory result in a fatal exception,
> > > which can now happen because of kmemleak scans:
> > > 
> > > [...]
> > 
> > Applied to fixes, thanks!
> > 
> > [1/1] KVM: arm64: Prevent kmemleak from accessing pKVM memory
> >       commit: 9e5afa8a537f742bccc2cd91bc0bef4b6483ee98
> 
> I'd really like to update the changelog to this:
> 
> Commit a7259df76702 ("memblock: make memblock_find_in_range method
> private") changed the API using which memory is reserved for the pKVM
> hypervisor. However, memblock_phys_alloc() differs from the original API in
> terms of kmemleak semantics -- the old one didn't report the reserved
> regions to kmemleak while the new one does. Unfortunately, when protected
> KVM is enabled, all kernel accesses to pKVM-private memory result in a
> fatal exception, which can now happen because of kmemleak scans:
> 
> $ echo scan > /sys/kernel/debug/kmemleak
> [   34.991354] kvm [304]: nVHE hyp BUG at: [<ffff800008fa3750>] __kvm_nvhe_handle_host_mem_abort+0x270/0x290!
> ...
> 
> Fix this by explicitly excluding the hypervisor's memory pool from
> kmemleak like we already do for the hyp BSS.

Looks good to me, thanks.

Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
