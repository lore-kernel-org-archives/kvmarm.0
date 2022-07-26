Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46EBAC00140
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 18:15:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F3F64C897;
	Tue, 26 Jul 2022 14:15:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gNvmYIqlHjQu; Tue, 26 Jul 2022 14:15:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44E914C899;
	Tue, 26 Jul 2022 14:15:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFF244C894
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 14:15:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GLcslMI5UmoU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 14:15:37 -0400 (EDT)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E8A84C893
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 14:15:37 -0400 (EDT)
Received: by mail-pf1-f182.google.com with SMTP id w205so10594649pfc.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 11:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=jonilkYeLeji6w0q1utqHOw7NcUFd3AQwKuUxxy5xkk=;
 b=EVbixTL9gnqd1y7HrB/47zqS9vmyDYH2HYAHNiUzmJmN8mNiY7yNJBaN7G6RDKtlpS
 ZxS0cLaQj4T0l1pQskWYrh7aL/ivz5tEaFrU+KE3OLSc+gUkfSOATT5WMuu3mbYQX8V5
 n3zIy/jvCCsL0OVXKEseq2ZqWQtgHRRJs+C6Qr6JrdyIHXHMiiFOovVlSRGok7yCa1Ib
 eXyvZGLsVKGTZ4I5qRXgReoQV8cyuX63pjZZs0vBn3URjvuBWKMTBb1Y2MK8OisN5wk5
 d79tOlFdbEKkBqHD4+7fFp7BNH0sBvhhSiuRXMjVF/JmDgXa7X2B1i8PQy0S7GNQYG/A
 pZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=jonilkYeLeji6w0q1utqHOw7NcUFd3AQwKuUxxy5xkk=;
 b=kWqQShk0vHKouPAm2tJwLSQ9TzAvQiXT7DKJMLA5429xeU921efQcSDRVcnRhIpx1v
 aNsrGOavBtOMOT05R0IY9Z1Cri5h5GqMedPHqY5u536cy+JiMCUGYZmuPs5TACzdXL2R
 bNAyJkhpMoLw8d3+nkf3RGSY0U9Dm9PHEGT3bvS0lY5j+CEMlgg0Am/rnILn66g7mXwy
 g769dSMzPzTTmFoioun0/6fv74cpX5mK5nVa+4JlCXzWDvLxQYhvXROnHMq4pNvB4YS2
 fOWAQzC4oc/dMJiFX0TSLRY6eBHKmvRT8PP9IpNR5VKvBbPX/QglxjlTGFxaM+xCh7sq
 k1ew==
X-Gm-Message-State: AJIora+tXT4zkBVpbu5YYCn9zFHG511uZYBVqFwEIykjz8evTEbGPdhB
 gaH8VjRU06sqdwrlZOKuJz56UQ==
X-Google-Smtp-Source: AGRyM1vnVXo3+810BCIhz5D/T/ksU1Pu4bBF1aFjn4F0TJjOtSO9l4FEKf24qxLQjMCiaACEfgAS/g==
X-Received: by 2002:a63:8ac3:0:b0:419:c3bb:7d99 with SMTP id
 y186-20020a638ac3000000b00419c3bb7d99mr16188219pgd.57.1658859336401; 
 Tue, 26 Jul 2022 11:15:36 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 30-20020a63185e000000b0041296bca2a8sm10145376pgy.12.2022.07.26.11.15.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Jul 2022 11:15:35 -0700 (PDT)
Date: Tue, 26 Jul 2022 18:15:31 +0000
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [PATCH v4 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YuAvQ0C8ZprtJ4US@google.com>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-10-ricarkol@google.com>
 <Ytir/hbU9neBaYqb@google.com> <YtrcCeHqBcwy+Mf6@google.com>
 <YtrqVwSK42KbKckf@google.com>
 <20220723082201.ifme5dipygt5r2wx@kamzik>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220723082201.ifme5dipygt5r2wx@kamzik>
Cc: drjones@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 axelrasmussen@google.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Sat, Jul 23, 2022, Andrew Jones wrote:
> On Fri, Jul 22, 2022 at 06:20:07PM +0000, Sean Christopherson wrote:
> > On Fri, Jul 22, 2022, Ricardo Koller wrote:
> > > What about dividing the changes in two.
> > > 
> > > 	1. Will add the struct to "__vm_create()" as part of this
> > > 	series, and then use it in this commit. There's only one user
> > > 
> > > 		dirty_log_test.c:   vm = __vm_create(mode, 1, extra_mem_pages);
> > > 
> > > 	so that would avoid having to touch every test as part of this patchset.
> > > 
> > > 	2. I can then send another series to add support for all the other
> > > 	vm_create() functions.
> > > 
> > > Alternatively, I can send a new series that does 1 and 2 afterwards.
> > > WDYT?
> > 
> > Don't do #2, ever. :-)  The intent of having vm_create() versus is __vm_create()
> > is so that tests that don't care about things like backing pages don't have to
> > pass in extra params.  I very much want to keep that behavior, i.e. I don't want
> > to extend vm_create() at all.  IMO, adding _anything_ is a slippery slope, e.g.
> > why are the backing types special enough to get a param, but thing XYZ isn't?
> > 
> > Thinking more, the struct idea probably isn't going to work all that well.  It
> > again puts the selftests into a state where it becomes difficult to control one
> > setting and ignore the rest, e.g. the dirty_log_test and anything else with extra
> > pages suddenly has to care about the backing type for page tables and code.
> > 
> > Rather than adding a struct, what about extending the @mode param?  We already
> > have vm_mem_backing_src_type, we just need a way to splice things together.  There
> > are a total of four things we can control: primary mode, and then code, data, and
> > page tables backing types.
> > 
> > So, turn @mode into a uint32_t and carve out 8 bits for each of those four "modes".
> > The defaults Just Work because VM_MEM_SRC_ANONYMOUS==0.
> 
> Hi Sean,
> 
> How about merging both proposals and turn @mode into a struct and pass
> around a pointer to it? Then, when calling something that requires @mode,
> if @mode is NULL, the called function would use vm_arch_default_mode()
> to get a pointer to the arch-specific default mode struct.

One tweak: rather that use @NULL as a magic param, #define VM_MODE_DEFAULT to
point at a global struct, similar to what is already done for __aarch64__.

E.g.

	__vm_create(VM_MODE_DEFAULT, nr_runnable_vcpus, 0);

does a much better job of self-documenting its behavior than this:

	__vm_create(NULL, nr_runnable_vcpus, 0);

> If a test needs to modify the parameters then it can construct a mode struct
> from scratch or start with a copy of the default. As long as all members of
> the struct representing parameters, such as backing type, have defaults
> mapped to zero for the struct members, then we shouldn't be adding any burden
> to users that don't care about other parameters (other than ensuring their
> @mode struct was zero initialized).

I was hoping to avoid forcing tests to build a struct, but looking at all the
existing users, they either use for_each_guest_mode() or just pass VM_MODE_DEFAULT,
so in practice it's a complete non-issue.

The page fault usage will likely be similar, e.g. programatically generate the set
of combinations to test.

So yeah, let's try the struct approach.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
