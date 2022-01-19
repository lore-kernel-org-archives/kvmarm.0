Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF7BC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 19 Jan 2022 00:07:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C62649DF6;
	Tue, 18 Jan 2022 19:07:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HH-20DLtaT88; Tue, 18 Jan 2022 19:07:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C418C49E2A;
	Tue, 18 Jan 2022 19:07:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A763849E1A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 19:07:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Za-RZ9bgvJfN for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jan 2022 19:07:50 -0500 (EST)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9D08E49DF6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 19:07:50 -0500 (EST)
Received: by mail-pf1-f182.google.com with SMTP id r5so866411pfl.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 16:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=vAxUGBdxlByR43mCEdZpVjv0Zz9WIa7OMWfFPmEbMTk=;
 b=qBXZz3eV8Rov2cm1W3wCt0Wf5F4ztIaFimefC7TG1Rnsledjc6d3hrI2tmNnsnk5ds
 46g8Nl6YqHfQImsWCVu9ZE/+2+quk+HTgCOPTzKEjkoXOnZ/ShhHtxfonlnThm8Ihtq8
 PmKepSxLMvuRUptYU7UdU5+d1atrnaYttTrpddGtCSVLAjHnyElfzJcEzcnQLw3PQKqf
 gWNb3gFBRJpOBXG7e758cFocItjh3GRGCOt2WYq0JFuxKSF1WgHrGbinNWK/SjAdgKbF
 RVY5+MHZdltx0CezKaIfkDI54ms+HBx7lceqPVX8LfnWyUumSYbbMdxiDhBKyxUT9p1W
 k7lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=vAxUGBdxlByR43mCEdZpVjv0Zz9WIa7OMWfFPmEbMTk=;
 b=fWaNHtaKFDNOV6FIXJ+FLSmch3KMJPUbCpfAKQyCCRftaWDMJe3c+RTyM9gqZIxzv7
 c2xloPNZK/eMKXq3mg1SiXOS/M9deEgLvscOtZV+DinZlRd0LwNqqKk7Z7ip+rxcPyDR
 L9AA1seRtke9gBjrHh4vJPLDgNn1Ht041rYA5FSgmB6dsCl6NybVcnM1/4j/MRagpqx3
 +G/qDRuW08ikeQTpIN15saFayN7Dmbquqh0JOHYkmcIFhONG8vGDNre5+Zojmnj62exw
 G4L5vKKMIHYdYMXnJ+zQZ0bGajJL770MVjpTDg0vlNlZTV+VY+6uOcU8BfDIF3p0lOkh
 Jd+g==
X-Gm-Message-State: AOAM530AnAfSD6StLAB+fMvDZz3WQZ8aJnHQNb63HYeht0kXrski9LUE
 tD+7r6pE9P29NnzT7RFrWC2RLw==
X-Google-Smtp-Source: ABdhPJxPq8SLTjE6n9JfYMFuQM1fFo8QhRlyyDWq9vPyshu5dZQT3oKCJx+oL4oaffzzN4FevbTMSQ==
X-Received: by 2002:a63:d417:: with SMTP id a23mr9394020pgh.297.1642550869199; 
 Tue, 18 Jan 2022 16:07:49 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id n11sm13527252pgm.1.2022.01.18.16.07.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 18 Jan 2022 16:07:48 -0800 (PST)
Date: Wed, 19 Jan 2022 00:07:44 +0000
From: Sean Christopherson <seanjc@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
Message-ID: <YedWUJNnQK3HFrWC@google.com>
References: <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
 <CALMp9eQDzqoJMck=_agEZNU9FJY9LB=iW-8hkrRc20NtqN=gDA@mail.gmail.com>
 <CAJHc60xZ9emY9Rs9ZbV+AH-Mjmkyg4JZU7V16TF48C-HJn+n4A@mail.gmail.com>
 <CALMp9eTPJZDtMiHZ5XRiYw2NR9EBKSfcP5CYddzyd2cgWsJ9hw@mail.gmail.com>
 <CAJHc60xD2U36pM4+Dq3yZw6Cokk-16X83JHMPXj4aFnxOJ3BUQ@mail.gmail.com>
 <CALMp9eR+evJ+w9VTSvR2KHciQDgTsnS=bh=1OUL4yy8gG6O51A@mail.gmail.com>
 <CAJHc60zw1o=JdUJ+sNNtv3mc_JTRMKG3kPp=-cchWkHm74hUYA@mail.gmail.com>
 <YeBfj89mIf8SezfD@google.com>
 <CAAeT=Fz2q4PfJMXes3A9f+c01NnyORbvUrzJZO=ew-LsjPq2jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=Fz2q4PfJMXes3A9f+c01NnyORbvUrzJZO=ew-LsjPq2jQ@mail.gmail.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Jim Mattson <jmattson@google.com>
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

On Fri, Jan 14, 2022, Reiji Watanabe wrote:
> The restriction, with which KVM doesn't need to worry about the changes
> in the registers after KVM_RUN, could potentially protect or be useful
> to protect KVM and simplify future changes/maintenance of the KVM codes
> that consumes the values.

That sort of protection is definitely welcome, the previously mentioned CPUID mess
on x86 would have benefit greatly by KVM being restrictive in the past.  That said,
hooking KVM_RUN is likely the wrong way to go about implementing any restrictions.
Running a vCPU is where much of the vCPU's state is explicitly consumed, but it's
all too easy for KVM to implicity/indirectly consume state via a different ioctl(),
e.g. if there are side effects that are visible in other registers, than an update
can also be visible to userspace via KVM_{G,S}ET_{S,}REGS, at which point disallowing
modifying state after KVM_RUN but not after reading/writing regs is arbitrary and
inconsitent.

If possible, preventing modification if kvm->created_vcpus > 0 is ideal as it's
a relatively common pattern in KVM, and provides a clear boundary to userpace
regarding what is/isn't allowed.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
