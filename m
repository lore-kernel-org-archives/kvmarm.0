Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D3833F2
	for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 23:19:37 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-59b5d4a8242so19600927b3.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Sep 2023 16:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694733577; x=1695338377; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4dPufiPQCtPzWz5WHSfvhHWIcWm8zH/JZg221REQo40=;
        b=RzmDMFhIHMikguP00xJhal02gEwYt26gJ6oGmAgl+MrDekpDMaah1zsk6GjHF2yimB
         SIYda1QDVD+HiTS0O1C0sLyntMyk+dJbh3hyBIK7tMxzs9+xLxoqyX+jWRscpVD06A5t
         w5nTljpAyacLj7L96F+tPgvJx2YZi4sSePTnzPBTp11gsIpEGD27hkWmNocZXYtHN8nx
         6/eIt+NSI1S5+A8i2wppBUNKM+Rxb6mj3C+ESFvqJLl/CUdVSnnDsA7DZAF9uWYosrZc
         GNsVNK5uTMqFYnS4tpXluNdiFjEz3wjNshsizzCRZK6+WqTJ9MGUJC/TwkLPV11XJ6Pp
         8aKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694733577; x=1695338377;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4dPufiPQCtPzWz5WHSfvhHWIcWm8zH/JZg221REQo40=;
        b=hNfqg0e5o+HSi8nuKcNJ7prGKa9KH2PmJswqWU+/Rd4tfjnC5vmcRYsTKcT+rj7pj5
         eMWK8Ak2FFd3Cg8b5J2+4za32VjZF9heO5cHEsJAbuRR4RmsdQ2fl0v41y7Q5ekOClNd
         lJ5n4SjwtnS06ebtGkOhrr6fIYWmn/qDnnpRLryQxeV0WiJKGU8IyD52uQxrHWecMq4o
         qseTsnaC9Fwd0Bb7K9DiEdroa4fINKtsewprzQDL73bwIM/eyl9FqmtnU7WDJOlIJCUD
         iqwYWqhDNx65c6b8rsEajFosL6ycc6l3GAGMSFI+fLfxZT0wgm1z4ox4sGNBpqTnj+7/
         8Efg==
X-Gm-Message-State: AOJu0YybMfIXGoA5oWf/QzPG/h2CFPL7j278Gyh3ZahT96kEGCIRq1jd
	4rbuIzuDTv4FxT+NLfJtLUO6Nwj1HZgR2JjuOw==
X-Google-Smtp-Source: AGHT+IGXEzZPfzBJslkSHoMTui4zDBSgnXtUGummxt07D80J/zY1rCAlKy2IgGo0zSECxNr/ULgwmLbLuPQoPz0S1A==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a25:aa83:0:b0:d77:984e:c770 with SMTP
 id t3-20020a25aa83000000b00d77984ec770mr158034ybi.5.1694733576882; Thu, 14
 Sep 2023 16:19:36 -0700 (PDT)
Date: Thu, 14 Sep 2023 23:19:34 +0000
In-Reply-To: <ZQNN2AyDJ8dF0/6D@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ZOO782YGRY0YMuPu@google.com> <diqzttsiu67n.fsf@ackerleytng-ctop.c.googlers.com>
 <ZQNN2AyDJ8dF0/6D@google.com>
Message-ID: <diqzv8ccjqbd.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	willy@infradead.org, akpm@linux-foundation.org, paul@paul-moore.com, 
	jmorris@namei.org, serge@hallyn.com, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	chao.p.peng@linux.intel.com, tabba@google.com, jarkko@kernel.org, 
	yu.c.zhang@linux.intel.com, vannapurve@google.com, mail@maciej.szmigiero.name, 
	vbabka@suse.cz, david@redhat.com, qperret@google.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Aug 28, 2023, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> >> If we track struct kvm with the inode, then I think (a), (b) and (c) can
>> >> be independent of the refcounting method. What do you think?
>> >
>> > No go.  Because again, the inode (physical memory) is coupled to the virtual machine
>> > as a thing, not to a "struct kvm".  Or more concretely, the inode is coupled to an
>> > ASID or an HKID, and there can be multiple "struct kvm" objects associated with a
>> > single ASID.  And at some point in the future, I suspect we'll have multiple KVM
>> > objects per HKID too.
>> >
>> > The current SEV use case is for the migration helper, where two KVM objects share
>> > a single ASID (the "real" VM and the helper).  I suspect TDX will end up with
>> > similar behavior where helper "VMs" can use the HKID of the "real" VM.  For KVM,
>> > that means multiple struct kvm objects being associated with a single HKID.
>> >
>> > To prevent use-after-free, KVM "just" needs to ensure the helper instances can't
>> > outlive the real instance, i.e. can't use the HKID/ASID after the owning virtual
>> > machine has been destroyed.
>> >
>> > To put it differently, "struct kvm" is a KVM software construct that _usually_,
>> > but not always, is associated 1:1 with a virtual machine.
>> >
>> > And FWIW, stashing the pointer without holding a reference would not be a complete
>> > solution, because it couldn't guard against KVM reusing a pointer.  E.g. if a
>> > struct kvm was unbound and then freed, KVM could reuse the same memory for a new
>> > struct kvm, with a different ASID/HKID, and get a false negative on the rebinding
>> > check.
>> 
>> I agree that inode (physical memory) is coupled to the virtual machine
>> as a more generic concept.
>> 
>> I was hoping that in the absence of CC hardware providing a HKID/ASID,
>> the struct kvm pointer could act as a representation of the "virtual
>> machine". You're definitely right that KVM could reuse a pointer and so
>> that idea doesn't stand.
>> 
>> I thought about generating UUIDs to represent "virtual machines" in the
>> absence of CC hardware, and this UUID could be transferred during
>> intra-host migration, but this still doesn't take host userspace out of
>> the TCB. A malicious host VMM could just use the migration ioctl to copy
>> the UUID to a malicious dumper VM, which would then pass checks with a
>> gmem file linked to the malicious dumper VM. This is fine for HKID/ASIDs
>> because the memory is encrypted; with UUIDs there's no memory
>> encryption.
>
> I don't understand what problem you're trying to solve.  I don't see a need to
> provide a single concrete representation/definition of a "virtual machine".  E.g.
> there's no need for a formal definition to securely perform intrahost migration,
> KVM just needs to ensure that the migration doesn't compromise guest security,
> functionality, etc.
>
> That gets a lot more complex if the target KVM instance (module, not "struct kvm")
> is a different KVM, e.g. when migrating to a different host.  Then there needs to
> be a way to attest that the target is trusted and whatnot, but that still doesn't
> require there to be a formal definition of a "virtual machine".
>
>> Circling back to the original topic, was associating the file with
>> struct kvm at gmem file creation time meant to constrain the use of the
>> gmem file to one struct kvm, or one virtual machine, or something else?
>
> It's meant to keep things as simple as possible (relatively speaking).  A 1:1
> association between a KVM instance and a gmem instance means we don't have to
> worry about the edge cases and oddities I pointed out earlier in this thread.
>

I looked through this thread again and re-read the edge cases and
oddities that was pointed out earlier (last paragraph at [1]) and I
think I understand better, and I have just one last clarification.

It was previously mentioned that binding on creation time simplifies the
lifecycle of memory:

"(a) prevent a different VM from *ever* binding to the gmem instance" [1]

Does this actually mean

"prevent a different struct kvm from *ever* binding to this gmem file"

?

If so, then binding on creation

+ Makes the gmem *file* (and just not the bindings xarray) the binding
  between struct kvm and the file.
+ Simplifies the KVM-userspace contract to "this gmem file can only be
  used with this struct kvm"

Binding on creation doesn't offer any way to block the contents of the
inode from being used with another "virtual machine" though, since we
can have more than one gmem file pointing to the same inode, and the
other gmem file is associated with another struct kvm. (And a strut kvm
isn't associated 1:1 with a virtual machine [2])

The point about an inode needing to be coupled to a virtual machine as a
thing [2] led me to try to find a single concrete representation of a
"virtual machine".

Is locking inode contents to a "virtual machine" outside the scope of
gmem? If so, then it is fine to bind on creation time, use a VM ioctl
over a system ioctl, and the method of refcounting in gmem v12 is okay.

[1] https://lore.kernel.org/lkml/ZNKv9ul2I7A4V7IF@google.com/
[2] https://lore.kernel.org/lkml/ZOO782YGRY0YMuPu@google.com/

> <snip>
