Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792741455;
	b=FZm+50GKq2Snzk3EKKvj6hWl2FL4XyralciMaqGP4yVMSPbLc94KdXTxYskAih+L4PxD
	 WDDkCYD7r2u0Xk6SVIAb558Nz0nTBwZMv8B0F+sxEXZItfKcFLO8NjkYqyvJx4gSP7k3l
	 6RofpFqBQRTN95SZdeGvmqJU0sKe7JgiMnwxsje3XqFlVEn1K5IBhnQf7P7TCwh1X1rZw
	 sfhxvnvSn2127b+IDOwOYjA15vDHAH7iHtkOOJeGfiVN8c0CZ9nGVb69T+UJYUpbPJLvp
	 VVA9pyYNvs0+abtFFnrRhalxQiOTvkGVZAA/ASLBZx3+9oB7mWAnqjAA77R8Eid/Lyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792741455;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=wy/cnaPswmms/QpZfcVOeHijhXMXPHn20ADaK91xPcA=;
	b=dTsoxeNIRIxZI1vaI3Lp6J5Wu0xUaKAOvp7jDDOt+XF8ElN/o/XvgD7DCZagn8ZyRF1r
	 NthybCoaYGGKUJViF/YxRto8cyGYJDBsqCY+1RfwQ7FYFQ5ZJLsKRAe/xxOrsIkzSEwl7
	 XyP7GyoZMAPhgPNA+coXjyMnQq1oJJcniXP3OW9yCEZC66/eAxx/1dB++6iP4jR0jUexH
	 YuCg7CIP5+FU4Aam3pZUmDkSwJv4u109N6iM1Vz7Y+a2SimmVzbn5DX6bK3pD6XnBvjDq
	 UOwo8tx5UeiBShwdpNFTsGciMwsfvgkLC20G6PqBOkG0VEmA5bryqmS1+qUOCa+OClw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EaM7GVz8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E82E606A31A;
	Fri, 23 Oct 2026 07:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EaM7GVz8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9170D1F01825;
	Fri, 23 Oct 2026 07:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792741455;
	bh=wy/cnaPswmms/QpZfcVOeHijhXMXPHn20ADaK91xPcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EaM7GVz8N1F1WL1rJOnrhPXJUtKGkqsv14MRU42ie3CqopgX3LNFxUDnl1OPNUi/e
	 2iQPCPAmrugokeUqdjjGnxoE/8npZif6jkFURSIYhrlahltUYFVTdLrUtWmi4bJDt4
	 uJpg0nOqXHeMjeyusKILIH3Cl4Mf3vGvpiVoTnLCyKCJvnhkOfk8IhqWDgFcrVZDsw
	 RQJc+E3xcDPh7iuKo7qjMm+aQPiRzX97cIhkWDsUcyao4CJSpPFEH+7iNFyZcmmnZH
	 r3znD2zes+BCcnM/Q+slSfn7Uk5g9JQYqOi58zhfrrPLbNKPn/9s/EmGcuM+9Ol3+7
	 YAzLqgDZtmCpA==
Date: Fri, 23 Oct 2026 10:44:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: tarunsahu@google.com
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	David Matlack <dmatlack@google.com>, jgg@nvidia.com,
	robin.murphy@arm.com, loganodell@google.com, oupton@kernel.org,
	kevin.tian@intel.com, alex@shazbot.org, dwmw2@infradead.org,
	pbonzini@redhat.com, seanjc@google.com, will@kernel.org,
	Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/4] liveupdate: Rename handler compatible to name
Message-ID: <atsQQcUiVhb9KXWZ@kernel.org>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-2-tarunsahu@google.com>
 <CA+CK2bC_wc4LxvHe0TREbBP7esYW3pcMNtkGK-kqvf6MyvOh2g@mail.gmail.com>
 <9huzik2u6hs5.fsf@tarunix.c.googlers.com>
 <CA+CK2bDyk=F7W3J=q3pKCjsr2wy_PLdgqgu+ywp0F5HL=VoMpA@mail.gmail.com>
 <9huzld7q4zjz.fsf@tarunix.c.googlers.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9huzld7q4zjz.fsf@tarunix.c.googlers.com>

On Wed, Oct 21, 2026 at 07:35:28PM +0000, tarunsahu@google.com wrote:
> Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> > On Wed, Oct 21, 2026 at 2:16 PM <tarunsahu@google.com> wrote:
> >> Pasha Tatashin <pasha.tatashin@soleen.com> writes:
> >>
> >> > On Wed, Oct 21, 2026 at 11:25 AM Tarun Sahu <tarunsahu@google.com> wrote:
> >> >>
> >> >> File handler and File-Lifecycle-Bound (FLB) identifiers name the
> >> >
> >> > Please use FLB directly, no need to spell it out.
> >> >
> >> >> registered handler or FLB rather than a monolithic compatibility version.
> >> >> Rename compatible to name across LUO headers, structures, and consumers:
> >> >> - struct liveupdate_file_handler and struct luo_file_ser name field
> >> >> - LIVEUPDATE_HNDL_NAME_LENGTH (in include/uapi/linux/liveupdate.h) and
> >> >>   MEMFD_LUO_FH_NAME
> >> >> - struct liveupdate_flb name field, LIVEUPDATE_FLB_NAME_LENGTH,
> >> >>   PCI_LUO_FLB_NAME, and LIVEUPDATE_TEST_FLB_NAME
> >> >>
> >> >> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> >> >> ---
> >> >>  drivers/pci/liveupdate.c        | 10 ++++----
> >> >>  include/linux/kho/abi/luo.h     | 26 +++++++++----------
> >> >>  include/linux/kho/abi/memfd.h   |  4 +--
> >> >>  include/linux/kho/abi/pci.h     |  2 +-
> >> >>  include/linux/liveupdate.h      | 18 +++++--------
> >> >>  include/uapi/linux/liveupdate.h |  3 +++
> >> >>  kernel/liveupdate/luo_file.c    | 45 +++++++++++++++++----------------
> >> >>  kernel/liveupdate/luo_flb.c     | 16 ++++++------
> >> >>  lib/tests/liveupdate.c          | 22 ++++++++--------
> >> >>  mm/memfd_luo.c                  |  2 +-
> >> >>  10 files changed, 73 insertions(+), 75 deletions(-)
> >> >>
> >> >> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> >> >> index 51695782ed42..3cf01d7d615c 100644
> >> >> --- a/drivers/pci/liveupdate.c
> >> >> +++ b/drivers/pci/liveupdate.c
> >> >> @@ -424,7 +424,7 @@ static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
> >> >>
> >> >>  static struct liveupdate_flb pci_liveupdate_flb = {
> >> >>         .ops = &pci_liveupdate_flb_ops,
> >> >> -       .compatible = PCI_LUO_FLB_COMPATIBLE,
> >> >> +       .name = PCI_LUO_FLB_NAME,
> >> >>  };
> >> >>
> >> >>  static void pci_liveupdate_flb_put_outgoing(void)
> >> >> @@ -667,13 +667,13 @@ static struct pci_flb_incoming *pci_liveupdate_flb_get_incoming(void)
> >> >>
> >> >>         /*
> >> >>          * Live Update is enabled and there is incoming FLB data, but none of it
> >> >> -        * matches pci_liveupdate_flb.compatible.
> >> >> +        * matches pci_liveupdate_flb.name.
> >> >>          */
> >> >>         if (ret == -ENOENT)
> >> >>                 return NULL;
> >> >>
> >> >>         /*
> >> >> -        * There is incoming FLB data that matches pci_liveupdate_flb.compatible
> >> >> +        * There is incoming FLB data that matches pci_liveupdate_flb.name
> >> >>          * but retrieve failed (pci_flb_retrieve() returned an error or LUO
> >> >>          * failed to acquire a reference to pci_liveupdate_flb_ops.owner).
> >> >>          */
> >> >> @@ -998,7 +998,7 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_is_incoming);
> >> >>   */
> >> >>  int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
> >> >>  {
> >> >> -       pr_debug("Registering file handler \"%s\"\n", fh->compatible);
> >> >> +       pr_debug("Registering file handler \"%s\"\n", fh->name);
> >> >>         return liveupdate_register_flb(fh, &pci_liveupdate_flb);
> >> >>  }
> >> >>  EXPORT_SYMBOL_GPL(pci_liveupdate_register_flb);
> >> >> @@ -1009,7 +1009,7 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_register_flb);
> >> >>   */
> >> >>  void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh)
> >> >>  {
> >> >> -       pr_debug("Unregistering file handler \"%s\"\n", fh->compatible);
> >> >> +       pr_debug("Unregistering file handler \"%s\"\n", fh->name);
> >> >>         liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
> >> >>  }
> >> >>  EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_flb);
> >> >> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> >> >> index 288076de6d4a..5fb2f46425d7 100644
> >> >> --- a/include/linux/kho/abi/luo.h
> >> >> +++ b/include/linux/kho/abi/luo.h
> >> >> @@ -39,9 +39,9 @@
> >> >>   *     Multiple blocks are linked via the `next` field in the header.
> >> >>   *
> >> >>   *   - struct luo_file_ser:
> >> >> - *     Metadata for a single preserved file. Contains the `compatible` string to
> >> >> - *     find the correct handler in the new kernel, a user-provided `token` for
> >> >> - *     identification, and an opaque `data` handle for the handler to use.
> >> >> + *     Metadata for a single preserved file. Contains the handler `name` string
> >> >> + *     to find the correct handler in the new kernel, a user-provided `token`
> >> >> + *     for identification, and an opaque `data` handle for the handler to use.
> >> >>   *
> >> >>   *   - struct luo_flb_header_ser:
> >> >>   *     Header for the FLB array. Contains the total page count of the
> >> >> @@ -49,9 +49,9 @@
> >> >>   *     that follow.
> >> >>   *
> >> >>   *   - struct luo_flb_ser:
> >> >> - *     Metadata for a single preserved global object. Contains its `name`
> >> >> - *     (compatible string), an opaque `data` handle, and the `count`
> >> >> - *     number of files depending on it.
> >> >> + *     Metadata for a single preserved global object. Contains its FLB `name`
> >> >> + *     string, an opaque `data` handle, and the `count` number of files
> >> >> + *     depending on it.
> >> >>   */
> >> >>
> >> >>  #ifndef _LINUX_KHO_ABI_LUO_H
> >> >> @@ -84,18 +84,16 @@ struct luo_ser {
> >> >>         u64 flbs_pa;
> >> >>  } __packed;
> >> >>
> >> >> -#define LIVEUPDATE_HNDL_COMPAT_LENGTH  48
> >> >> -
> >> >>  /**
> >> >>   * struct luo_file_ser - Represents the serialized preserves files.
> >> >> - * @compatible:  File handler compatible string.
> >> >> + * @name:        File handler name string.
> >> >
> >> > We are renaming from cpmaptible to name; I am not sure that is
> >> > necessary. We can still use compatible for the same purpose as name.
> >> > Unless it really bothers people, but for me 'compatible' works just
> >> > the same.
> >>
> >> Yes it is necessary, For example if we have two handler for a single
> >> subsystem. We should refer it by handle this or handler that, not like
> >> handler with compatible string this and handler with compatible string
> >> that.
> >
> > I still feel like compatability makes more sense to me. Take an example:
> >
> > We have two file handlers for memfd (i.e., FH_OLD and FH_NEW): one has
> > compatibility = "memfd", and the other has compatibility =
> > "memfd_next_generation". The user chooses one of them to preserve the
> > memfd data, and the compatibility string is saved alongside the FD.
> > When the next kernel scans through the registered file handlers, it
> > must find exactly one that is compatible with the preserved data.
> 
> I will open this for vote.

I'd rather won't ;-)

"compatible" does not contradict more fine grained bitfields, and still has meaning.
Just like in FDT world from where we inherited it, it means "these ops are
somewhat compatible with that serialized format, will check the details and
will know for sure".

And IMO we should keep it.
 
And please, trim your responses. I had to scroll 463 lines to see there's
nothing there.

-- 
Sincerely yours,
Mike.
