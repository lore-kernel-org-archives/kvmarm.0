Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F230C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 21:44:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 74F4D64FCD
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 21:44:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 74F4D64FCD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7D664B1B4;
	Wed, 10 Mar 2021 16:44:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z+aS6rMnYO0M; Wed, 10 Mar 2021 16:44:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDB5C4B1C0;
	Wed, 10 Mar 2021 16:44:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FC824B1B3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 16:44:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y5RNNmQRNMwC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 16:44:06 -0500 (EST)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
 [209.85.167.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3527D4B1A8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 16:44:06 -0500 (EST)
Received: by mail-lf1-f53.google.com with SMTP id v2so23077161lft.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 13:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=+At1OFsJvT0JOYczrtSDaeg1RlqRvgFnN9ibJip5xME=;
 b=qkR47YAxd7W+12meJHOokTY86zM5TK5Wusnmh13Uxu6NKYuWOWiLQGc+P2AFImuiLA
 ORloLJ5jSdrdT/bdHqp0DqklfhSIS7mEsK7M0vc6oJuwRJflhTJDhz132bRJTuHxQ+kO
 RInZN11KZCoVG6SxxC7xs6XJmagTxp4jzMdyWhd7EKrDtUQBY/A2tTYflsQ1uYhuPyd3
 zAAkVHP8jzsjKtNt8i07AloD2E4Y+rbcN6P6aA+VHiEEec2aQ0pLVAnU5FG2ZdTYiTPl
 Vuh0I/S8kIlI0b/tAdley4Z5qQ9yZunB4iev6lY8EGMaF3EkJrMb2vFP3F+H3DRihlGh
 rj2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=+At1OFsJvT0JOYczrtSDaeg1RlqRvgFnN9ibJip5xME=;
 b=Nh8flxytaBK1XTbRihSVnPQl2VrdbrxwHz5ou5qrJc1tYwY74eREJdr3PereyXgOjx
 4IDcfCFEYJnxb2ehRCGMOOvjvSV6On3eBIuCXqAQ5gZIYPfugDXiw4YoY/U/AggJuz2S
 j9eatJg9v4lSOpp+6Hb7fjfMhogg2QINkHnDwr4fRMChGSVi9dA0oIptZr2L94apTw1M
 YK3izbf0I6MhMqTmISOfPU5y75PW33IW3KQaN7i3c8cN+nwmM1Ip2bg7U6eazTCMzzyp
 tBGryc+QWEJTWAObDKk+h1IWUNaKl7W+zwQSa16fJgP3q2iCkfr5vuIHB5iADrcIwcs0
 nEaA==
X-Gm-Message-State: AOAM533mty73To+Cyqpptmke2yrBGAFyrFfdUijt03FpgantaW7+wp1U
 FcpJLIXqFKRl5vmtqVdTqI2cOrrauEtBr+jBkEG9sw==
X-Google-Smtp-Source: ABdhPJzfPcaCkdhotikZXLd9A3857WsFY8DpxVP062dOT18HhG4a9S9hO0jkkklXHezJ/dUgXnUVkP98iZMz90iTzX0=
X-Received: by 2002:a19:4345:: with SMTP id m5mr302440lfj.178.1615412644377;
 Wed, 10 Mar 2021 13:44:04 -0800 (PST)
MIME-Version: 1.0
References: <20210310003024.2026253-1-jingzhangos@google.com>
 <20210310003024.2026253-4-jingzhangos@google.com>
 <875z1zxb11.wl-maz@kernel.org>
 <a475d935-e404-93dd-4c6d-a5f8038d8f4d@redhat.com>
 <8735x3x7lu.wl-maz@kernel.org>
 <2749fe68-acbb-8f4d-dc76-4cb23edb9b35@redhat.com>
 <871rcmhq43.wl-maz@kernel.org>
 <fd37d21f-f3ae-d370-f8e1-cf552be3b2ee@redhat.com>
In-Reply-To: <fd37d21f-f3ae-d370-f8e1-cf552be3b2ee@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 10 Mar 2021 15:43:53 -0600
Message-ID: <CAAdAUtjQHh3CEedcjZ5qQ72JZiacjogPoaKBO03vNbiQo=u5+g@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] KVM: stats: Add ioctl commands to pull statistics
 in binary format
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linux kselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 Linux S390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVM PPC <kvm-ppc@vger.kernel.org>,
 Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, Linux MIPS <linux-mips@vger.kernel.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Wed, Mar 10, 2021 at 11:44 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 10/03/21 18:31, Marc Zyngier wrote:
> >> Maintaining VM-global counters would require an atomic instruction and
> >> would suffer lots of cacheline bouncing even on architectures that
> >> have relaxed atomic memory operations.
> > Which is why we have per-cpu counters already. Making use of them
> > doesn't seem that outlandish.
>
> But you wouldn't be able to guarantee consistency anyway, would you?
> You *could* copy N*M counters to userspace, but there's no guarantee
> that they are consistent, neither within a single vCPU nor within a
> single counter.
>
> >> Speed/efficiency of retrieving statistics is important, but let's keep
> >> in mind that the baseline for comparison is hundreds of syscalls and
> >> filesystem lookups.
> >
> > Having that baseline in the cover letter would be a good start, as
> > well as an indication of the frequency this is used at.
>
> Can't disagree, especially on the latter which I have no idea about.
>
> Paolo
>
Marc, Paolo, thanks for the comments. I will add some more information
in the cover letter.

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
