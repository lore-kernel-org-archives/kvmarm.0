Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D88C433FE
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 10:15:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9244D613D2
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 10:15:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9244D613D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 210444B280;
	Mon,  4 Oct 2021 06:15:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 452aso35tba3; Mon,  4 Oct 2021 06:15:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31E304B238;
	Mon,  4 Oct 2021 06:15:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31E9B4B238
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 06:15:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oPirnvD4p0Hq for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 06:15:24 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CEA54B22C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 06:15:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633342524;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=yDF1c1dqYgH2Cwme9oa02nYdGNUhXjuRR+mKl+EbFaI=;
 b=SuJS+ZUXF3ebZRXrn9KzAkGZZ6JJja6fCJgFJ2x7DtH3byWZcNMyhqeFU3R6jmEqN14lca
 Xwc86DLw5F160QUyeGJStDq0UJYojVqmmUQ1HIQPZEdI7ABAEmNzhb91mPeiG7wulbanLk
 cwbmo/ZUh6YJKitP7AQtj+Yw1ZxBgRc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-nlFcHhw_Or6N7bUSb-llMg-1; Mon, 04 Oct 2021 06:15:23 -0400
X-MC-Unique: nlFcHhw_Or6N7bUSb-llMg-1
Received: by mail-wr1-f70.google.com with SMTP id
 r15-20020adfce8f000000b0015df1098ccbso4486432wrn.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 03:15:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=yDF1c1dqYgH2Cwme9oa02nYdGNUhXjuRR+mKl+EbFaI=;
 b=UhkyrHIM7teJhU+tDTIu/MTLQMewxeBC5yUlnvbcwVCPzwpUUc4098FpW+T0icTA8w
 mZ0jRfq+ifHulGPn91FDu6cr2PKn7bHmfT4AeVpOKpVJ86nnZWh4DsElbbbECJ8+j4SG
 IdcdyQy6ppFBtNgaIMVR96Z/tcb99/KXTkOA/wGWet5wdNz4C5nZ2Zp1Ml6HpQawCi9N
 5RFGMsjiLhYA/Vhlmlh3b8jrZnf+oFmiDJEy3WRlynZ3R18XCqZDYTnCz0++8+75zaD4
 tTSs4tDgyPNjzvy4ZOBS102ThtcaU9uc+YWknVPkoANRe7XNjFc1pHbqJLcIQV06uxyX
 kJWw==
X-Gm-Message-State: AOAM530MSBtvYhSZTmBsP6N1B/5PYNv5u0QuR3bM3GTb9O73kzbZEsQe
 tMY7pgnLCtcwI6LpjthRK+3hYjxLRGE++uD+Nbv1QpGUIx382C28L8Kl67jd4OQp1nXMXjXn4eS
 Go5wYc3oGdjPwDNCnZ6r72cVC
X-Received: by 2002:adf:8b41:: with SMTP id v1mr9713733wra.255.1633342522131; 
 Mon, 04 Oct 2021 03:15:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRStbmwZwWa77a0AnUFnuhdU26j6wRpa9Rnhj7K3iPzyC6wV10RHSZQFJAaQQey6pPDse5KA==
X-Received: by 2002:adf:8b41:: with SMTP id v1mr9713703wra.255.1633342521934; 
 Mon, 04 Oct 2021 03:15:21 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id v23sm13920203wmj.4.2021.10.04.03.15.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Oct 2021 03:15:21 -0700 (PDT)
Date: Mon, 4 Oct 2021 12:15:20 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 4/5] hw/arm/virt: Use the PA range to compute the
 memory map
Message-ID: <20211004101520.6sqx2jubmqd6djhb@gator>
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-5-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211003164605.3116450-5-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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

On Sun, Oct 03, 2021 at 05:46:04PM +0100, Marc Zyngier wrote:
...
> @@ -1662,9 +1665,17 @@ static void virt_set_memmap(VirtMachineState *vms)
>          vms->memmap[i].size = size;
>          base += size;
>      }
> -    vms->highest_gpa = (vms->highmem ?
> -                        base :
> -                        vms->memmap[VIRT_MEM].base + ms->maxram_size) - 1;
> +
> +    /*
> +     * If base fits within pa_bits, all good. If it doesn't, limit it
> +     * to the end of RAM, which is guaranteed to fit within pa_bits.
> +     */
> +    if (base <= BIT_ULL(pa_bits)) {
> +        vms->highest_gpa = base -1;
                                    ^ missing space here

> +    } else {
> +        vms->highest_gpa = memtop - 1;
> +    }
> +
>      if (device_memory_size > 0) {
>          ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
>          ms->device_memory->base = device_memory_base;

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
