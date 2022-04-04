Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D7C6C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 18:39:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D8604B2BB;
	Mon,  4 Apr 2022 14:39:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@ziepe.ca
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PNLteIwFHZIG; Mon,  4 Apr 2022 14:39:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FF7349E08;
	Mon,  4 Apr 2022 14:39:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF7D54B27E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 13:02:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TPLaHid1JvYD for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 13:02:05 -0400 (EDT)
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com
 [209.85.219.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 764D14B27C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 13:02:05 -0400 (EDT)
Received: by mail-qv1-f44.google.com with SMTP id ke15so7929482qvb.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 10:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ziepe.ca; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ldaf9TCMiXf7fL1dfzaYzOZ+TQNop4UbheNTFjQvaPQ=;
 b=DILSNJNq+rL63EuAH3jYTlZXN2YyTH/lzUbBGFQNH3SKIfZSE8jtgB2QmtM5bBleyw
 MLBizaWPQO1/lE94wIbJUlSiC6cM3dXdJIisc8aUf2yoSUMfKMsPyKsi24GOdA6D85YE
 /xYzfGZ2Uer3WxSQoCfrclLAfoTuH4Fcj5wl4ZL2lKeY9xTdW4y2r7vH0Qa9KWA+s+sh
 eMW38qinbbSNeGkgM0ll86nvFu1HOIY6USJXxD3No14R1YOb1vnuKBB5+hiDcfo9OOI0
 8YGcQbCbgiBWilV+E6cxwKlycInhIHJLriWoBz3LjEpseXjVVckMCkeVNRUynYgBz2hV
 aQ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ldaf9TCMiXf7fL1dfzaYzOZ+TQNop4UbheNTFjQvaPQ=;
 b=ct3r0CGla1duBeVjmX78cjwDbuhp3lGjJF8VAnax2HCkTtnw8yx5TPc342altKXfQB
 dUaFxuZv8TZKYvQZI0s8HbFK2Ox/ieY+qe3o6h99X+ICTNaFjJ1CAuw48y9Y/RuCs+lM
 sIIRRgsih1kmzYCX1mU4vRYoLTnUFcNQDOwGujXavFJBgBIBqDgOP64L9H0+r0RBhXuh
 hWG5Mu8zz2PMKAsePqVWzJ/z6478ukzisgCJSv78xVLzG6s/s6DNjRMNUPi6LitU9nF7
 FtQ76DjOFdulfmo+HldrhoUlrX4Qg+OgQ3Z5AqrFPWa3j++3hlhA/VojcUcKaSY0YPcz
 Hu0w==
X-Gm-Message-State: AOAM531o38/LHiXsCgvkFzE6mB1OXdaVrcpDRCLaMuq8KqXrSHqP/GKW
 O2s+YSfGVQPXTswM4BndsV5h1w==
X-Google-Smtp-Source: ABdhPJy/HBdadnCNKiofw8Pq8aQUNK1kcH5nxeVllxEF7eiEPlBVFzDcAkFaS7EwH4xr9jAPm9bxpA==
X-Received: by 2002:a05:6214:1c85:b0:443:8347:d7a5 with SMTP id
 ib5-20020a0562141c8500b004438347d7a5mr508563qvb.11.1649091724773; 
 Mon, 04 Apr 2022 10:02:04 -0700 (PDT)
Received: from ziepe.ca
 (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net.
 [142.162.113.129]) by smtp.gmail.com with ESMTPSA id
 n8-20020ac85a08000000b002e06aa02021sm9070384qta.49.2022.04.04.10.02.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Apr 2022 10:02:03 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94) (envelope-from <jgg@ziepe.ca>)
 id 1nbQ5a-00CUal-Fs; Mon, 04 Apr 2022 14:02:02 -0300
Date: Mon, 4 Apr 2022 14:02:02 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2] kvm/arm64: fixed passthrough gpu into vm on arm64
Message-ID: <20220404170202.GR64706@ziepe.ca>
References: <20220401090828.614167-1-xieming@kylinos.cn>
 <87tubcbvgk.wl-maz@kernel.org> <20220404132405.GQ64706@ziepe.ca>
 <87o81gc3dc.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87o81gc3dc.wl-maz@kernel.org>
X-Mailman-Approved-At: Mon, 04 Apr 2022 14:39:56 -0400
Cc: sashal@kernel.org, catalin.marinas@arm.com, linux@armlinux.org.uk,
 linux-kernel@vger.kernel.org, xieming <xieming@kylinos.cn>,
 alex.williamson@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Mon, Apr 04, 2022 at 03:47:11PM +0100, Marc Zyngier wrote:
> > I'm guessing it will turn into a SBSA like thing where the ARM ARM is
> > kind of vauge but a SOC has to implement Normal-NC in a certain way to
> > be functional for the server market.
> 
> The main issue is that this equivalence isn't architected, so people
> can build whatever they want. SBSA means nothing to KVM (or Linux at
> large), and there is currently no way to describe which devices are
> safe to map as Normal-NC vs Device.

And people have, we know of some ARM SOC's that don't work fully with
NORMAL_NC for this usage. That is already a problem for baremetal
Linux, let alone KVM..

That is why I likened it to SBSA - if you want to build a server SOC
that works with existing server software, you have to support
NORMAL_NC in this way. Even if it isn't architected.

The KVM challenge, at least, is to support a CPU with working
NORMAL_NC to create VM that emulates the same CPU with working
NORMAL_NC.

I didn't quite understand your other remarks though - is there a
problem here? It seems like yes from the other thread you pointed at?

I would think that KVM should mirror the process page table
configuration into the KVM page table and make this into a userspace
problem?

That turns it into a VFIO problem to negotiate with userspace and set
the proper pgprot. At least VFIO has a better chance than KVM to
consult DT or something to learn about the specific device's
properties.

I don't know how VFIO/qemu/etc can make this all work automatically
correctly 100% of the time. It seems to me it is the same problem as
just basic baremetal "WC" is troubled on ARM in general today. Maybe
some tables and a command line option in qemu is the best we can hope
for.

Long ago I asked that the ARM folks could come with some Linux
definition of all the WC-like modes and some arch calls to indicate
which one(s) should be used. Nobody seemed interested in doing that,
so the above SOC was left non-working in mainline Linux..

> We either have to take userspace's word for it, or rely on some other
> heuristics (do this for PCIe, but not anything else). None of which
> are entirely safe. Not to mention that no currently available CPU
> implements FEAT_DGH.

DHG is an optimization, not a functional requirement. Currently
available CPUs use one of the more expensive barriers that are
architected to include DHG behavior.

In any event, this is an important optimization. It is why ARMv9 is
introducing a new instruction specifically to optmize it.

Jason
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
