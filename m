Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1F2C10F0E
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 01:34:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E779920880
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 01:34:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="t56JIJp9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E779920880
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79AD24A321;
	Sun,  7 Apr 2019 21:34:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yICZCimiWQSb; Sun,  7 Apr 2019 21:34:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EF474A452;
	Sun,  7 Apr 2019 21:34:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CF7C4A331
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 21:34:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NOtrsePlpeYV for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 Apr 2019 21:34:50 -0400 (EDT)
Received: from mail-yw1-f65.google.com (mail-yw1-f65.google.com
 [209.85.161.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 393AF4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 21:34:50 -0400 (EDT)
Received: by mail-yw1-f65.google.com with SMTP id j66so4360651ywc.10
 for <kvmarm@lists.cs.columbia.edu>; Sun, 07 Apr 2019 18:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=94R1PsB3DOvrvTb4L+SuN8cpW6ir/jjUWNee5sxFAwA=;
 b=t56JIJp9Z+taxl58zDxj126cBjzW2MJrq9M+DRfRtjaaTVGruRWAJZe5wti1xmy0Jk
 g93iT8KuFUWg6I1pLCRs/WGJI7xfa0vvgOs6ed/QmmQQ9aa3pufT2bBw9HunZ5axZ0tl
 smsopvTFHG/pkzhH0+JkU9D7tzE22bB3T8n2gHB2MFZBcptNZEjXGY+VKqyvsZs8WBmk
 xd/gaLn5/7esVa3lBU96DsG+tvYrCpUEpeHdp9B6CdPnK34ZjDNgFv+qr+HthWvSEPKx
 vMOjdRQdhHZUEQWceBF/YSj3DLP5094id+gfzkCQr9gw5VJI8nSSS0SpDR8Mixi4y5vj
 LxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:subject:message-id:references
 :mime-version:content-disposition:in-reply-to:user-agent;
 bh=94R1PsB3DOvrvTb4L+SuN8cpW6ir/jjUWNee5sxFAwA=;
 b=eesH4DRDFrmFeDMmpoaBKnR2MMuVUuxNxtD4mUp/Ykz64PWNCZ6feeZgwn/6lA1wrW
 9XCBU9Ue0um5Vz/mjKG/ahGiu6w7kRHzCgfY9FWbXZAkQBPcsqDSJYunormlBWJFDiig
 nwCR3pWJ1TOyoHj4mCn/aBpB03+EprgGGIISHxVPKqvfg6Vf0rbmGn0jUt/Gt5qT9/BW
 NeHDSPap0mdzFbvzMQay6lARt8FFxXOQ1kwzA+iy7XJc886wLEV/E3G6uGuZOZ1VmDAf
 iRvjlEPWrykEJXBo6BF2mGZDvfhkJUNgYmWVn8+8AKGoMQhue6lmi+xt7HwBydgF2bKH
 ApyQ==
X-Gm-Message-State: APjAAAUoswQkZFw+Ki0UVQM4kZ5smH6Hnu6f/nfEaPCbl1DGCOo/yGys
 GTRHF8DbkzjesR4tVb887wz8ug==
X-Google-Smtp-Source: APXvYqzn1PliCtFjz8vasmNLaeFoFVGdcqFswu1IclRGeH8o8VoJa06HSp2a43e+Ei1t/KvconLyaw==
X-Received: by 2002:a81:1393:: with SMTP id 141mr21053423ywt.140.1554687289666; 
 Sun, 07 Apr 2019 18:34:49 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li931-65.members.linode.com.
 [45.56.113.65])
 by smtp.gmail.com with ESMTPSA id 207sm9641421ywv.9.2019.04.07.18.34.46
 (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
 Sun, 07 Apr 2019 18:34:48 -0700 (PDT)
Date: Mon, 8 Apr 2019 09:34:42 +0800
From: Leo Yan <leo.yan@linaro.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
 Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH] vfio-pci: Fix MSI IRQ forwarding for without per-vector
 masking
Message-ID: <20190408013442.GA10011@leoy-ThinkPad-X240s>
References: <20190322052308.28254-1-leo.yan@linaro.org>
 <20190322052924.GB31904@leoy-ThinkPad-X240s>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190322052924.GB31904@leoy-ThinkPad-X240s>
User-Agent: Mutt/1.9.4 (2018-02-28)
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190408013442.zEPEwcnIICjO_vg6d5OdvlnBcnF2pnWn5FvT6NETmkg@z>

Hi Jean-Philippe,

On Fri, Mar 22, 2019 at 01:29:24PM +0800, Leo Yan wrote:
> On Fri, Mar 22, 2019 at 01:23:08PM +0800, Leo Yan wrote:
> > If MSI doesn't support per-vector masking capability and
> > PCI_MSI_FLAGS_MASKBIT isn't set in message control field, the function
> > vfio_pci_msi_vector_write() will directly bail out for this case and
> > every vector's 'virt_state' keeps setting bit VFIO_PCI_MSI_STATE_MASKED.
> > 
> > This results in the state maintained in 'virt_state' cannot really
> > reflect the MSI hardware state; finally it will mislead the function
> > vfio_pci_update_msi_entry() to skip IRQ forwarding with below flow:
> > 
> > vfio_pci_update_msi_entry() {
> > 
> >   [...]
> > 
> >   if (msi_is_masked(entry->virt_state) == msi_is_masked(entry->phys_state))
> >       return 0;  ==> skip IRQ forwarding
> > 
> >   [...]
> > }
> > 
> > To fix this issue, when detect PCI_MSI_FLAGS_MASKBIT is not set in the
> > message control field, this patch simply clears bit
> > VFIO_PCI_MSI_STATE_MASKED for all vectors 'virt_state'; at the end
> > vfio_pci_update_msi_entry() can forward MSI IRQ successfully.
> 
> Just remind, this patch is for kvmtool but not for kernel.  Sorry I
> forget to add it in subject.

Gentle ping.  Not sure if this patch is reasonable, could you help to
give a review?

[...]

Thanks,
Leo Yan
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
