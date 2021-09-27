Return-Path: <SRS0=UlWN=OR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A71C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 17:33:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8F9D360E09
	for <kvmarm@archiver.kernel.org>; Mon, 27 Sep 2021 17:33:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8F9D360E09
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC15B4A98B;
	Mon, 27 Sep 2021 13:33:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xOk0bL3OPTVg; Mon, 27 Sep 2021 13:33:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D48234A7FD;
	Mon, 27 Sep 2021 13:33:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A5934A7FD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 13:33:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f2hiBYvietZh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Sep 2021 13:33:46 -0400 (EDT)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8BC8849F8F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 13:33:46 -0400 (EDT)
Received: by mail-pj1-f43.google.com with SMTP id
 lb1-20020a17090b4a4100b001993f863df2so603878pjb.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Sep 2021 10:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=QVPOqaNlq7I3lDhzzEE0LSlmqb5BJv1DMZ8alEx/1nI=;
 b=d285SG2vMoj7fWGLcc6kCiR/YbFmwFZ0r8FCUF/olwvOpdIeZoqHfRZvaCPNzDsw+I
 DXfTdpdYvY1o3+xwclpJFqsOx9rx8gXxXILEPFDMXqDFGp4BJoLLTpbwH1u1XP+r1Qam
 5szAUX8Uoct9SyiacXSLIaEMZeN1EKkEAgcpyL12gNGSfsGKRyH2m+hvt+6VnU5P+65Q
 0VTTYCcD9hk6ReQ9O9Swq7+ugPD0ecGhrBD3WfyuwTtr/uZVPNTBMwKAB7m8BgvxcC2+
 1ahXM7yNRUThnsg8QBfYfkaFmzHfumEXxhUu0VeZLeiCqPy+iDDU2pSUPBkNE2SVw6+C
 hGgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=QVPOqaNlq7I3lDhzzEE0LSlmqb5BJv1DMZ8alEx/1nI=;
 b=zppHQfTk/ilaVS490ZljxfhjyP7rmKBgnVq6Tq/dAxR/hbLm8xKkTXbe+SpQMhIudw
 FXpp3kS8EpBEJxTc5JEbUZW/ofHAwNlQCCWnocgGcQAvhyTcyLr0QpbRc5CR2hy8o8L4
 6R1ieLhDD1GsuSCEzJmoPMjWE9LzDBLNDa09YXHvh6D3jij9q377wXqMta+AxW4ux+Wv
 lySThboFmwOzH5+udTuISD5H6TOZOivdPgMfdXLqx5puYs7+vF0qaeV0fzA5gbE6cmOc
 5SMF9GTfaG9oifdxqcPsQ35A1V0vsogK/cED37C4UVi12RzTpV48tATCw4Fqj36PB/rk
 F89A==
X-Gm-Message-State: AOAM531bhUz2wy0uqq9VdkDecQaGxZWw5n0S8oEZ/2WKcvVroe+TtgzL
 qlhCpS7vqLvRmS0WIHRep9hKPg==
X-Google-Smtp-Source: ABdhPJyGE9PssoIO8hd/mc9M/bvKl7HfH1PbwL6q6ROscf2AvxLZZUXzLqFUTTNdwUlFUFuHe69vkw==
X-Received: by 2002:a17:90b:224b:: with SMTP id
 hk11mr253513pjb.231.1632764025351; 
 Mon, 27 Sep 2021 10:33:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id o17sm18385346pfp.126.2021.09.27.10.33.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Sep 2021 10:33:44 -0700 (PDT)
Date: Mon, 27 Sep 2021 17:33:41 +0000
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: disabling halt polling broken? (was Re: [PATCH 00/14] KVM:
 Halt-polling fixes, cleanups and a new stat)
Message-ID: <YVIAdVxc+q2UWB+J@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <03f2f5ab-e809-2ba5-bd98-3393c3b843d2@de.ibm.com>
 <YVHcY6y1GmvGJnMg@google.com>
 <f37ab68c-61ce-b6fb-7a49-831bacfc7424@redhat.com>
 <43e42f5c-9d9f-9e8b-3a61-9a053a818250@de.ibm.com>
 <CABgObfYtS6wiQe=BhF3t5usr7J6q4PWE4=rwZMMukfC9wT_6fA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABgObfYtS6wiQe=BhF3t5usr7J6q4PWE4=rwZMMukfC9wT_6fA@mail.gmail.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 David Hildenbrand <david@redhat.com>, "Kernel Mailing List,
 Linux" <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Jon Cargille <jcargill@google.com>, kvm-ppc <kvm-ppc@vger.kernel.org>,
 David Matlack <dmatlack@google.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 "open list:MIPS" <linux-mips@vger.kernel.org>,
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

On Mon, Sep 27, 2021, Paolo Bonzini wrote:
> On Mon, Sep 27, 2021 at 5:17 PM Christian Borntraeger
> <borntraeger@de.ibm.com> wrote:
> > > So I think there are two possibilities that makes sense:
> > >
> > > * track what is using KVM_CAP_HALT_POLL, and make writes to halt_poll_ns follow that
> >
> > what about using halt_poll_ns for those VMs that did not uses KVM_CAP_HALT_POLL and the private number for those that did.
> 
> Yes, that's what I meant.  David pointed out that doesn't allow you to
> disable halt polling altogether, but for that you can always ask each
> VM's userspace one by one, or just not use KVM_CAP_HALT_POLL. (Also, I
> don't know about Google's usecase, but mine was actually more about
> using KVM_CAP_HALT_POLL to *disable* halt polling on some VMs!).

I kinda like the idea if special-casing halt_poll_ns=0, e.g. for testing or
in-the-field mitigation if halt-polling is broken.  It'd be trivial to support, e.g.

@@ -3304,19 +3304,23 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
                update_halt_poll_stats(vcpu, start, poll_end, !waited);

        if (halt_poll_allowed) {
+               max_halt_poll_ns = vcpu->kvm->max_halt_poll_ns;
+               if (!max_halt_poll_ns || !halt_poll_ns)  <------ squish the max if halt_poll_ns==0
+                       max_halt_poll_ns = halt_poll_ns;
+
                if (!vcpu_valid_wakeup(vcpu)) {
                        shrink_halt_poll_ns(vcpu);
-               } else if (vcpu->kvm->max_halt_poll_ns) {
+               } else if (max_halt_poll_ns) {
                        if (halt_ns <= vcpu->halt_poll_ns)
                                ;
                        /* we had a long block, shrink polling */
                        else if (vcpu->halt_poll_ns &&
-                                halt_ns > vcpu->kvm->max_halt_poll_ns)
+                                halt_ns > max_halt_poll_ns)
                                shrink_halt_poll_ns(vcpu);
                        /* we had a short halt and our poll time is too small */
-                       else if (vcpu->halt_poll_ns < vcpu->kvm->max_halt_poll_ns &&
-                                halt_ns < vcpu->kvm->max_halt_poll_ns)
-                               grow_halt_poll_ns(vcpu);
+                       else if (vcpu->halt_poll_ns < max_halt_poll_ns &&
+                                halt_ns < max_halt_poll_ns)
+                               grow_halt_poll_ns(vcpu, max_halt_poll_ns);
                } else {
                        vcpu->halt_poll_ns = 0;
                }
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
