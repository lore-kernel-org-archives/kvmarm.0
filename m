Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A1FDC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 23 Jul 2022 08:22:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F5564CF1D;
	Sat, 23 Jul 2022 04:22:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U8inS85K8tbQ; Sat, 23 Jul 2022 04:22:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B0774CF2B;
	Sat, 23 Jul 2022 04:22:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 191CA4CF1D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Jul 2022 04:22:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hQkdRJvZ+old for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 Jul 2022 04:22:03 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADE3E4CF28
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Jul 2022 04:22:03 -0400 (EDT)
Date: Sat, 23 Jul 2022 10:22:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1658564522;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=aOSqEv8YSD1UI4ScPGrFOxLpl/551dfe7DtbQRV0qXo=;
 b=YuSzj1hAOW7jAHQrG5EY3zWWR38FI5+nuZWqNiLxGZA73exFo3iZA8kCpVMc47GYoVR4S+
 MDJn66D1g5bbRom+AA5RH1vArwQL2olcDHHp6A3gkRX2TB2h5xmExpVCW6+wtFWp4f8Efp
 KaGrl4px5jIH3A00MJecpC5CxpasNuE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v4 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <20220723082201.ifme5dipygt5r2wx@kamzik>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-10-ricarkol@google.com>
 <Ytir/hbU9neBaYqb@google.com> <YtrcCeHqBcwy+Mf6@google.com>
 <YtrqVwSK42KbKckf@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YtrqVwSK42KbKckf@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
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

On Fri, Jul 22, 2022 at 06:20:07PM +0000, Sean Christopherson wrote:
> On Fri, Jul 22, 2022, Ricardo Koller wrote:
> > On Thu, Jul 21, 2022 at 01:29:34AM +0000, Sean Christopherson wrote:
> > > If we don't care, and maybe even if we do, then my preference would be to
> > > enhance the __vm_create family of helpers to allow for specifying what
> > > backing type should be used for page tables, i.e. associate the info the VM
> > > instead of passing it around the stack.
> > > 
> > > One idea would be to do something like David Matlack suggested a while back
> > > and replace extra_mem_pages with a struct, e.g. struct kvm_vm_mem_params
> > > That struct can then provide the necessary knobs to control how memory is
> > > allocated.  And then the lib can provide a global
> > > 
> > > 	struct kvm_vm_mem_params kvm_default_vm_mem_params;
> > > 
> > 
> > I like this idea, passing the info at vm creation.
> > 
> > What about dividing the changes in two.
> > 
> > 	1. Will add the struct to "__vm_create()" as part of this
> > 	series, and then use it in this commit. There's only one user
> > 
> > 		dirty_log_test.c:   vm = __vm_create(mode, 1, extra_mem_pages);
> > 
> > 	so that would avoid having to touch every test as part of this patchset.
> > 
> > 	2. I can then send another series to add support for all the other
> > 	vm_create() functions.
> > 
> > Alternatively, I can send a new series that does 1 and 2 afterwards.
> > WDYT?
> 
> Don't do #2, ever. :-)  The intent of having vm_create() versus is __vm_create()
> is so that tests that don't care about things like backing pages don't have to
> pass in extra params.  I very much want to keep that behavior, i.e. I don't want
> to extend vm_create() at all.  IMO, adding _anything_ is a slippery slope, e.g.
> why are the backing types special enough to get a param, but thing XYZ isn't?
> 
> Thinking more, the struct idea probably isn't going to work all that well.  It
> again puts the selftests into a state where it becomes difficult to control one
> setting and ignore the rest, e.g. the dirty_log_test and anything else with extra
> pages suddenly has to care about the backing type for page tables and code.
> 
> Rather than adding a struct, what about extending the @mode param?  We already
> have vm_mem_backing_src_type, we just need a way to splice things together.  There
> are a total of four things we can control: primary mode, and then code, data, and
> page tables backing types.
> 
> So, turn @mode into a uint32_t and carve out 8 bits for each of those four "modes".
> The defaults Just Work because VM_MEM_SRC_ANONYMOUS==0.

Hi Sean,

How about merging both proposals and turn @mode into a struct and pass
around a pointer to it? Then, when calling something that requires @mode,
if @mode is NULL, the called function would use vm_arch_default_mode()
to get a pointer to the arch-specific default mode struct. If a test needs
to modify the parameters then it can construct a mode struct from scratch
or start with a copy of the default. As long as all members of the struct
representing parameters, such as backing type, have defaults mapped to
zero for the struct members, then we shouldn't be adding any burden to
users that don't care about other parameters (other than ensuring their
@mode struct was zero initialized).

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
