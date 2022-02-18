Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE9EC433EF
	for <kvmarm@archiver.kernel.org>; Sun, 20 Feb 2022 19:04:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AAA94B132;
	Sun, 20 Feb 2022 14:04:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1K1uYkMBCfaH; Sun, 20 Feb 2022 14:04:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8C0F4B183;
	Sun, 20 Feb 2022 14:04:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70BA1408D5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Feb 2022 06:28:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mSPM7HZaSb3T for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Feb 2022 06:28:10 -0500 (EST)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D126408AA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Feb 2022 06:28:10 -0500 (EST)
Received: by mail-pj1-f42.google.com with SMTP id b8so8294374pjb.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Feb 2022 03:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=PK/ubS/6VsrQfiT6fGu4snd5NM7nEqZO9rUfJO/NsiI=;
 b=n/cvs6OXRCT6uPZ/Yw7GOroXVfh58ytcqRxwlJXMudjxgtROBVythTC/elOjbwNC3u
 UH9nSTNV9ahF0MqrDCfr+DfIi8+vD4xNJ4qdK5ApItATZ0grW1xWnHAenvlSJ7NIIoj3
 0FK3cM95L6B3YdgR8Dp2MOJHgdED9iU6z2vgxjXLJxciDepCwVki4Kb96IOBfojKypXA
 AENFOrP9JnnwZ5pKQThwrwWgTut7f8LDlWtNTk4+Jk8ffzjg8/EXw7SI7nzgXFNsAFaT
 2FGQy82gtk3SROxpDsW0cDqTFGSozWPPDbNulKfLODuimfsD6DkJA3THtl2LYxKeKM1b
 T43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=PK/ubS/6VsrQfiT6fGu4snd5NM7nEqZO9rUfJO/NsiI=;
 b=aQPliQ1AeGeSj7mJj6GeyQSxKdr4UoN4COwuuyEaUWCCI6vyr8Dh+B+s2MYuCqrzuV
 oaqNH1mWribSd6GbZd8qEw7ir5a5DuV9jrhDypE5yIEGUs4l2qXp2eZK5xMf0AX3QZ6a
 q0FTGNAbl1YPIFauT+6aVWAjM7FHekQklFyfooGVkebMSZsPBdvT3zLViDuVlpucqfAH
 LIpw5cEOB0Y2QmmPLzZdt3DfyFI0htjC4ZRs7O1jqkTxZHJdKha2daPfJRbp8Xj9qQ9M
 9bG4MwAJfFMgLDna0J0ZZyd0On4i/BtEclAAXIP79pX0cFqdE5zS60JDY/MDBXjEkUt4
 zyzQ==
X-Gm-Message-State: AOAM532wDA1JpCRwYnX+7fu70SaKffA2vYsual/lnK8Be/g9bQNmRmX4
 OEFRko9GB2viA2Ugw0pr0bM=
X-Google-Smtp-Source: ABdhPJy3Gih8h6AYa+elDZwsK5cx+J5xZ+6EWCZm6XLpJpwnVTm7xeYAKheh5zAXCfPVi6sQ7lPfKw==
X-Received: by 2002:a17:903:143:b0:14d:44e7:5886 with SMTP id
 r3-20020a170903014300b0014d44e75886mr7051510plc.148.1645183689452; 
 Fri, 18 Feb 2022 03:28:09 -0800 (PST)
Received: from baohua-VirtualBox.localdomain (47-72-151-34.dsl.dyn.ihug.co.nz.
 [47.72.151.34])
 by smtp.gmail.com with ESMTPSA id ob12sm5222899pjb.5.2022.02.18.03.28.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 18 Feb 2022 03:28:09 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
X-Google-Original-From: Barry Song <song.bao.hua@hisilicon.com>
To: shankerd@codeaurora.org,
	will@kernel.org
Subject: Re: [PATCH] irqchip/gic-v3: Use wmb() instead of smb_wmb() in
 gic_raise_softirq()
Date: Fri, 18 Feb 2022 19:27:52 +0800
Message-Id: <20220218112752.9811-1-song.bao.hua@hisilicon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <1517443422-30693-1-git-send-email-shankerd@codeaurora.org>
References: <1517443422-30693-1-git-send-email-shankerd@codeaurora.org>
MIME-Version: 1.0
X-Mailman-Approved-At: Sun, 20 Feb 2022 14:04:07 -0500
Cc: tspeier@codeaurora.org, vikrams@codeaurora.org, scampbel@codeaurora.org,
 marc.zyngier@arm.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
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

> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -688,7 +688,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>  	 * Ensure that stores to Normal memory are visible to the
>  	 * other CPUs before issuing the IPI.
>  	 */
> -	smp_wmb();
> +	wmb();

Sorry for waking up the old thread. isn't dsb(ishst) enough here as we only
need to guarantee the visibility of data to other CPUs in smp inner domain
before we send the ipi?

> 
>  	for_each_cpu(cpu, mask) {
>  		u64 cluster_id = MPIDR_TO_SGI_CLUSTER_ID(cpu_logical_map(cpu));

Thanks
Barry

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
