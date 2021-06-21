Return-Path: <SRS0=rYk4=LP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F6DC4743C
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 23:39:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C83B611BD
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 23:39:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C83B611BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C35F4057F;
	Mon, 21 Jun 2021 19:39:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yDkbEj6t4LUK; Mon, 21 Jun 2021 19:39:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8504D401A4;
	Mon, 21 Jun 2021 19:39:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1973401A4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 19:39:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dTmbmrLfEoNt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jun 2021 19:39:01 -0400 (EDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com
 [209.85.167.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 971F240191
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 19:39:01 -0400 (EDT)
Received: by mail-lf1-f51.google.com with SMTP id a11so19870984lfg.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 16:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=LKCX3YjuqUNoE4+roGGfm8o2np78e+Xfu61B4cA+uJI=;
 b=QFcnGtA3VrPeLLWUQicj9F1i0h1b/5RybgGRdCxbzFL8QhdCFvqX8VwhHYX5q3Pqkr
 5doeAmEDeGxRt76VeDSVeTUadqoTA9u5/6KTlXOqcOXjJSNpNfPijSSqRT/k13mRT82w
 BkMfCbkNJslkTjpro+DkmBk3PjS4Hn6PXERxRUa93acO7MAGSIQkTHpMNoCVbbitEC/G
 3z40+VkdiWaBHfrDy1AVZ8PQ02ycaq32fh4zmxddeYVhD6TbyPzafSla/8UwQq8SJUic
 P+LJtxgksTY14V5S67BoAcB1O0z9RiIOsr1CYCnuSPJgiazaQKBcf7ytjA/ktHEpP3jT
 SeQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=LKCX3YjuqUNoE4+roGGfm8o2np78e+Xfu61B4cA+uJI=;
 b=M4GKB7jCwQEmvumzp/W+9KlTRyVQbgtmzWLj87o8Ml2y/ArqV/H5N52uHBPgk4aQjy
 bnbRvN8mpiES0xE278AcbWJI2Vny6+Ycq5HGaLIwW9aHBLgc5T5HIwmQKWJf4PvULUC+
 idDWRQAtVFKtox++lQ3YJtWNkoQnr+wuzepdXB8r8AeB+GCWTcT12eUPuBUrBaqySy4Z
 QGcv5cwdiYnTBYU3VyP2EyakaKy7K3TYNYGeg2PQ21keVdav8naVuZKw5+AFQ+P/t4vh
 TWQ2PLfNG++O5IFU/VtyV44EbqaLZk5k8qTAsHw2Y3PVQsbXHmfWK/Eftiqm2oJXb0Sb
 zP0Q==
X-Gm-Message-State: AOAM530bf36oVGb8lSbTLVw5kguiZ0pefeDGOXDqZuSv+nQKnP3UTFFf
 6KpI4IRSb9lv7GK9G1ReR5GjEOpFZmsOw5X35zhaOw==
X-Google-Smtp-Source: ABdhPJyDQGI0gLkASAQSuSpsPjVvNlP9W768H8z16TiAXAgKg2wBct7k8/lWvgPo4urmgneuo0U07ygTChCL7ubyJYY=
X-Received: by 2002:a05:6512:33c4:: with SMTP id
 d4mr592219lfg.536.1624318739777; 
 Mon, 21 Jun 2021 16:38:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210618222709.1858088-1-jingzhangos@google.com>
 <20210618222709.1858088-3-jingzhangos@google.com>
 <0cde024e-a234-9a10-5157-d17ba423939e@redhat.com>
 <CAAdAUtiL6DwJDWLLmUqct6B6n7Zaa2DyPhpwKZKb=cpRH+8+vQ@mail.gmail.com>
 <aa1d0bd9-55cf-161a-5af9-f5abde807353@redhat.com>
 <CAAdAUti1MreOnAXtA+jBEaq+AixmqvBEByi9G4EgDpfu63spHA@mail.gmail.com>
 <c639c557-0e16-6938-2da5-46400ee2dd14@redhat.com>
In-Reply-To: <c639c557-0e16-6938-2da5-46400ee2dd14@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 21 Jun 2021 18:38:49 -0500
Message-ID: <CAAdAUtgXAedsXf_1Mjp+mBNkZkHg9feirMpUYQFrYhQ=8vVFcg@mail.gmail.com>
Subject: Re: [PATCH v12 2/7] KVM: stats: Add fd-based API to read binary stats
 data
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 David Matlack <dmatlack@google.com>, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Jun 21, 2021 at 6:35 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 22/06/21 00:58, Jing Zhang wrote:
> >> Pass it as an argument?
> > The num_desc can only be initialized in the same file that defines the
> > descriptor array.
> > Looks like we have to have a global variable to save that. The
> > solution would be similar
> > to have a statically defined header for each arch.
> > So, keep the header structure for each arch?
>
> Oh, sorry.  I missed that there's only one call to kvm_stats_read and
> it's in common code.  The remaining comments are small enough that I can
> apply them myself.  Thanks!
>
> Paolo
>
Cool! Thanks, Paolo.

Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
