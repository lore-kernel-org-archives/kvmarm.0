Return-Path: <SRS0=srdq=LL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B315FC2B9F4
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 14:48:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 354CE613EA
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 14:48:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 354CE613EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6CD74A551;
	Thu, 17 Jun 2021 10:48:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OuTVxRMcGUYX; Thu, 17 Jun 2021 10:48:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5383B4B085;
	Thu, 17 Jun 2021 10:48:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AF254A551
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 10:48:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xJtE47z7JcWE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jun 2021 10:48:21 -0400 (EDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com
 [209.85.167.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 29D7749E5F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 10:48:21 -0400 (EDT)
Received: by mail-lf1-f41.google.com with SMTP id p7so10920617lfg.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 07:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=7xTcig9u+ckmAK7F7nxFSbFSF3LG6qPs6DaQp7FLrvY=;
 b=bygYJMkfBrOTcD5rgvdu2TqpUYCHPRA5N7W6suhW34MjzQ7Q41hSSaiV4p4h1kSB8B
 wtVqMlTitgQM18JdvB7h9Q+oFDUtZ5+vI4b0NNHWxiQOyhK6wSHPrWESvV/RMicAbEB2
 JONdfC82tVgGDbroHeVLo3Zu06osDZZ2CimkJypcMPXAcRddVw5QsLGliJLlP3ZRnfRW
 QBMeN4RVmbyQ6GXkM4cATYRg3sKqyvnFP/9pSO3RCyzzxmSghU06nl6L+xfZxsQeCtwA
 OxuR8KUTSn5/6zjnAcYoWUmGsLpODf/TMKL/SNbBxB4gcI/KyOtgXGVUlZqe9XP1j3C1
 Cw6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=7xTcig9u+ckmAK7F7nxFSbFSF3LG6qPs6DaQp7FLrvY=;
 b=KVUFQJ+I5w4hhHWs6i90vDaXp3Upr3Cl7g+dFiOXu8FCBODsyl/FwC+tEHm/94a/fc
 RWHaX1y7SXo7+bLo4DBhWEsRvFDfN8uKQXdbufM1mFqQXx3YB9HdyKRvG5hYUvQ5lcYF
 1tggzQxD8F8gKdH01ci+W/oXAS4hY4rTj2oivV2f3sktvSmKNcqZh0A7I4gd35xfTfNJ
 FWNRNUByAOWpQUk/fzCSUA3eWtGNa7V8OoMaYxFgxXENIgmJe8vV2qPNYWBswMHLQLUW
 tYcMb2SCF/k4Se279W4D6hJppZCt+yJ27TLgE7QV8SECsUFAbHj2xjDe+hrUPdJzl3sn
 YVGw==
X-Gm-Message-State: AOAM530WRZPofLq7/si10Fq2bEnrKhaluICBWTZ4M+qwhc3dSToAQAvd
 TuNXXcFnxRlOUuF6AvMXl1x8anGNf0rzRSGfVD3gQw==
X-Google-Smtp-Source: ABdhPJyAGNi+2863i+xt6PnvN+8SqM67FY0o8ilXr0tbP46MEwKu1YD9BBtN+J/dXZivkcBRgfa36w81fk2G41mFTyg=
X-Received: by 2002:a05:6512:318d:: with SMTP id
 i13mr4438454lfe.407.1623941299197; 
 Thu, 17 Jun 2021 07:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210617044146.2667540-1-jingzhangos@google.com>
 <20210617044146.2667540-3-jingzhangos@google.com> <YMrzzYEkDQNCpnP7@kroah.com>
In-Reply-To: <YMrzzYEkDQNCpnP7@kroah.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 17 Jun 2021 09:48:07 -0500
Message-ID: <CAAdAUtibbp4y_Ju4E+EeQ6HmRsEGXycjK-Y_P78xGVySYkftSQ@mail.gmail.com>
Subject: Re: [PATCH v10 2/5] KVM: stats: Add fd-based API to read binary stats
 data
To: Greg KH <greg@kroah.com>
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
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

Hi Greg,

On Thu, Jun 17, 2021 at 2:03 AM Greg KH <greg@kroah.com> wrote:
>
> On Thu, Jun 17, 2021 at 04:41:43AM +0000, Jing Zhang wrote:
> > Provides a file descriptor per VM to read VM stats info/data.
> > Provides a file descriptor per vCPU to read vCPU stats info/data.
> >
> > The KVM stats now is only accessible by debugfs, which has some
> > shortcomings this change are supposed to fix:
> > 1. Debugfs is not a stable interface for production and it is
> >    disabled when kernel Lockdown mode is enabled.
>
> debugfs _could_ be a stable interface if you want it to be and make that
> rule for your subsystem.  Disabling it for lockdown mode is a different
> issue, and that is a system-wide-policy-decision, not a debugfs-specific
> thing.
>
> > 2. Debugfs is organized as "one value per file", it is good for
> >    debugging, but not supposed to be used for production.
>
> debugfs IS NOT one-value-per-file, you can do whatever you want in
> there.  sysfs IS one-value-per-file, do not get the two confused there.
>
> > 3. Debugfs read/clear in KVM are protected by the global kvm_lock.
>
> That's your implementation issue, not a debugfs issue.
>
> The only "rule" in debugfs is:
>         There are no rules.
>
> So while your subsystem might have issues with using debugfs for
> statistics like this, that's not debugfs's fault, that's how you want to
> use the debugfs files for your subsystem.
>
You are right. The issues are from how the debugfs is used in KVM stats.
Will fix the text accordingly.
> > Besides that, there are some other benefits with this change:
> > 1. All KVM VM/VCPU stats can be read out in a bulk by one copy
> >    to userspace.
> > 2. A schema is used to describe KVM statistics. From userspace's
> >    perspective, the KVM statistics are self-describing.
> > 3. Fd-based solution provides the possibility that a telemetry can
> >    read KVM stats in a less privileged situation.
>
> "possiblity"?  Does this work or not?  Have you tested it?
>
I should've said "We are able to read KVM stats in a less privileged process".
> > +static ssize_t kvm_vm_stats_read(struct file *file, char __user *user_buffer,
> > +                           size_t size, loff_t *offset)
> > +{
> > +     struct kvm *kvm = file->private_data;
> > +
> > +     snprintf(&kvm_vm_stats_header.id[0], sizeof(kvm_vm_stats_header.id),
> > +                     "kvm-%d", task_pid_nr(current));
>
> Why do you write to this static variable for EVERY read?  Shouldn't you
> just do it once at open?  How can it change?
>
> Wait, it's a single shared variable, what happens when multiple tasks
> open this thing and read from it?  You race between writing to this
> variable here and then:
>
> > +     return kvm_stats_read(&kvm_vm_stats_header, &kvm_vm_stats_desc[0],
> > +             &kvm->stat, sizeof(kvm->stat), user_buffer, size, offset);
>
> Accessing it here.
>
> So how is this really working?
>
You are right. We only need to do it once at the open. Will fix it according to
Paolo's suggestion.
> thanks,
>
> greg k-h

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
