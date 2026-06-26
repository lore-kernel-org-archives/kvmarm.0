Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19323FAE1A;
	Fri, 26 Jun 2026 16:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782492295; cv=none; b=f1T2nvoyZ0h2WKef4k9PbW1xorcO4Z1UWGa0PM6TpvcluL39DT3k6x1THxW+Su4XxockEynDEoJ0cq6lKSM3290+citBj2mKkBKaRQZcJ3aeNXg6aC7Oax+XnbRRNB+1/+RkXHAvbZwzw6/HCVrc+5yJDzL3M31bHP8/TWYql5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782492295; c=relaxed/simple;
	bh=zzM9Tpslk2jGhnJU0P8TuM9NV7xNRpLJu+VgnbANdbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kb06ifeU2Tav8Le0FGu6FN1usuAZrMnm6sDvVE5Ssen7egHAbrYUqRJ0v61RIcjvcZVDf0SeE1fWTy1YMj4Ee2f2P0x9mjsXys5Ub4wi8wJ10rnLjj36juvt3D4XBhSQdiDW2vnlO5mELuVr2an3Oh5N4V+HG+7hGXWVrXzRJG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RblsZsm0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RblsZsm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4112D1F000E9;
	Fri, 26 Jun 2026 16:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782492293;
	bh=IIMKFrwzgRLP5t1Gt5PG42EY4TZLGzrHo7tbdnQ49uA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RblsZsm0QeSPqN0GVq67PJyDnlFgcmEG7eUjPJqUD//eJD6bA9qFtn/XA+ZAAOXZf
	 SWrEi/x6lmJKQHvp6COe4I3oEVwTABEKgtvqrjgYhkdi1llqjJ05KZD/cB8DnoLFfh
	 ytKZse/yhYO5VKR4JttvZUrQWaXlZoSdBufX7QZwrcK26p5UvZ89kUfim5o9DVZ6ul
	 pKAcKpUXK2WFLs2CE2dd+JJ3O83R4I89pyUHTGfefikEBf6AO91LHvZeYBaWDaLlxx
	 Ibpo/8DFHB3r0NEeXqdV1LPLz8c0Syky9JOrA5UaDYvoe2Jv/Wxg3O6g4x7NkuEPl/
	 oK13n0tP/tNDQ==
Date: Fri, 26 Jun 2026 18:44:39 +0200
From: Lorenzo Pieralisi <lpieralisi@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
	Lorenzo.Pieralisi2@arm.com
Subject: Re: [PATCH v14 29/44] arm64: RMI: Runtime faulting of memory
Message-ID: <aj6sdzlbxT8D5fnf@lpieralisi>
References: <20260513131757.116630-30-steven.price@arm.com>
 <3359f788-07fa-41a1-9ac7-45c58577c1fa@redhat.com>
 <aiJ6u83O0nVUtPyv@lpieralisi>
 <ecef952b-e8c6-4102-933b-c99c46f14431@redhat.com>
 <aiLes2ecZSr17UwZ@lpieralisi>
 <1e39094f-7fa3-4ef1-be54-53d7a8643506@redhat.com>
 <98d2a0f3-b831-466a-8212-5bcf97ad9d8b@arm.com>
 <8da87878-2a5d-478a-a280-60dbed7ad1b9@redhat.com>
 <9482dfbc-4d96-47ba-a615-f4ba0bda833f@arm.com>
 <8f81ed99-c53a-4196-baa2-adea9239a000@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f81ed99-c53a-4196-baa2-adea9239a000@redhat.com>

On Fri, Jun 26, 2026 at 09:43:03PM +1000, Gavin Shan wrote:
> On 6/26/26 6:47 PM, Suzuki K Poulose wrote:
> > On 26/06/2026 08:43, Gavin Shan wrote:
> > > On 6/26/26 1:58 AM, Suzuki K Poulose wrote:
> > > > On 25/06/2026 14:53, Gavin Shan wrote:
> > > > > On 6/6/26 12:35 AM, Lorenzo Pieralisi wrote:
> > > > > > On Fri, Jun 05, 2026 at 06:11:11PM +1000, Gavin Shan wrote:
> > > > > > > On 6/5/26 5:28 PM, Lorenzo Pieralisi wrote:
> > > > > > > > On Fri, Jun 05, 2026 at 04:23:15PM +1000, Gavin Shan wrote:
> > > 
> > > [...]
> > > 
> > > > > > > 
> > > > > > > I tried to rebase Jean's latest QEMU series [1] to upstream QEMU, and found
> > > > > > > that memory slots backed by THP are broken. With THP disabled on the host and
> > > > > > > other fixes (mentioned in my prevous replies) applied on the top of this (v14)
> > > > > > > series, I'm able to boot a realm guest with rebased QEMU series [2], plus more
> > > > > > > fxies on the top.
> > > > > > > 
> > > > > > > [1] https://git.codelinaro.org/linaro/dcap/qemu.git  (branch: cca/ latest)
> > > > > > > [2] https://git.qemu.org/git/qemu.git                (branch: cca/ gavin)
> > > > > > > 
> > > > > > > Lorenzo, You may be saying there is someone making QEMU to support ARM/CCA?
> > > > > > 
> > > > > > Mathieu and I are working on that yes and with Steven/Suzuki to fix the THP
> > > > > > issues you pointed out above.
> > > > > > 
> > > > > > > If so, I'm not sure if there is a QEMU repository for me to try?
> > > > > > 
> > > > > > We should be able to submit patches by end of June - we shall let you know
> > > > > > whether we can make something available earlier.
> > > > > > 
> > > > > 
> > > > > Not sure if there are other known issues in this series. It seems the stage2
> > > > > page fault handling on the shared space isn't working well. In my test, the
> > > > > vring (struct vring_desc) of virtio-net-pci is updated by the guest, and the
> > > > > data isn't seen by QEMU, I'm suspecting if the host-page-frame-number is properly
> > > > > resolved in the s2 page fault handler for shared (unprotected) space.
> > > > > 
> > > > > - I rebased Jean's latest qemu branch to the upstream qemu;
> > > > > 
> > > > > - On the host, which is emulated by qemu/tcg, the THP (transparent huge page) is
> > > > >    disabled.
> > > > > 
> > > > > - On the guest, I can see the virtio vring (struct vring_desc) is updated. The
> > > > >    S1 page-table entry looks correct because the corresponding physical address
> > > > >    0x10046880000 is a sane shared (unprotected) space address.
> > > > > 
> > > > >    [   52.094143] software IO TLB: Memory encryption is active and system is using DMA bounce buffers
> > > > >    [   52.289746] virtqueue_add_desc_split: desc[0]@0xffff000006880000, [00000100b983f000  00000640  0002  0001]
> > > > >    [   52.432150] PTE 0x00e8010046880707 at address 0xffff000006880000
> > > > > 
> > > > > - On the host, the s2 page-table-entry is unmapped due to attribute transition (private -> shared).
> > > > >    A subsequent S2 page fault is raised against the adress and the s2 page-table-entry is built.
> > > > > 
> > > > >    [  109.259077] ====> realm_unmap_shared_range: tracked_unprot_addr=0x10046880000
> > > > >    [  109.260249] realm_unmap_shared_range: unmapped shared range at 0x10046880000
> > > > >    [  109.317786] realm_unmap_shared_range: unmapped shared range at 0x10046880000
> > > > >    [  109.629939] ====> kvm_handle_guest_abort: fault_ipa=0x10046880000, esr=0x92000007
> > > > >    [  109.630245] realm_map_non_secure: ipa=0x10046880000, pfn=0xb8b59, size=0x1000, prot=0xf
> > > > >    [  109.630331] realm_map_non_secure: ipa=0x10046880000, ipa_top=0x10046881000, flags=0x1e0001, range_desc=0xb8b59004
> > > > 
> > > > Are you able to correlate the order of the transitions and the Guest
> > > > access with RMM log ? We haven't seen this from our end. We are aware
> > > > of permission fault issues with Unprotected IPA when backing the memslot
> > > > with MAP_PRIVATE areas. But this looks different.
> > > > 
> > > > Lorenzo, have you run into this ?
> > > > 
> > > 
> > > It's hard to correlate the order since the logs are collected from two separate
> > > consoles. For the write permission, I add code to the host where the permission
> > > is always added for all s2 page faults in the shared space. Otherwise, qemu can
> > > be killed by -EFAULT or similar error.
> > 
> > This is the problem. We can't add WRITE permission by default. I believe
> > you may have MAP_PRIVATE mapping and it has to be mapped as READ only
> > and on a permission fault, we replace it with a writable page. By
> > overriding the WRITE permission, you let the guest write to a page
> > that may not be seen by the VMM.
> > 
> > We identified this as a bug in the KVM driver in this series (reported
> > by Lorenzo) and there is a corresponding tf-RMM change that is required
> > to get this working. So, please could you wait until the next series
> > when this will be addressed ? Or you could switch to using MAP_SHARED
> > for the "shared" memory in the memslot.
> > 
> 
> Exactly. the syntax for MAP_PRIVATE is broken if the write permission is
> enforced for a read fault in the shared space. In my case, the host page can
> be the zero page and eventually multiple s2 page-table entries (for multiple
> unprotected or shared pages) point to the zero page. It's why clearing the
> 3rd queue (Ctrl queue) also clears the first queue (Rx queue) in my case.
> 
> Yes, this issue can be avoid by using a shared memory backend in qemu, something
> like below. With this, I'm able to see virtio-net-pci starts to work...
> 
>     -object memory-backend-ram,id=mem0,size=2G,share=yes

Yes, as Suzuki said that's what we have been fixing. QEmu patches
will be on the mailing lists very shortly - the KVM/tf-RMM fixes
to make MAP_PRIVATE work will be included in the next posting.

Feel free to drop your QEmu command line so that I can give it
a shot and check whether the fixes solve the problem you hit
(I think so because that's precisely the kind of issue I got
into when I started debugging THP/MAP_PRIVATE but it is better
to check).

Thanks,
Lorenzo
