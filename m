Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4FB43E9281
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 09:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782466695; cv=none; b=bM+MyHVCxFcVsiKtYdhnFqulh01OrZTs2bmhe7UaDbzU2JidIbCEQ8wcHPsyjEDjG1Kh2wzN0NYaN7cy343bNcN5tvxXFbVDmZ7S0JEYj2xzD4iidx4hU7tp2JHvBxqGgfmJ6feUdv9GHTncuQcmYEpNL6y7TrEeuhiF21hAj98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782466695; c=relaxed/simple;
	bh=meUP+Y0CS1ctaBI7eOPfAVVBnMsYGpnlBuYQQ6TBgvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAfIFJHU3zrb+MCtJ7SECv3THXVY2c7Qlmg+Dl3yV9W5BP8ZhG7iy2BKtjUToLAU+2iAU4iK+g0NufU+YvFRpOz9v0HZod1fm3FI91uyVqRwX6ZgQHnHFpl8nA7e3GlO3bl4/3PnyfEh0/0fZKY1gTlkfzDlwB5wu/OjCOPVE1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ogmJejkl; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ogmJejkl"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD049204C;
	Fri, 26 Jun 2026 02:38:07 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B0FCA3F836;
	Fri, 26 Jun 2026 02:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782466692; bh=meUP+Y0CS1ctaBI7eOPfAVVBnMsYGpnlBuYQQ6TBgvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ogmJejklrPg6Gl7OxBcpSgA/vb8kqaWxyD/jtOomRZifPgmNp6gk0xNAOYrchUmPH
	 eDbtd8VNaifCeE8NcEMhy6wXMhJiS8pGjWG90K6Ndy5DrUR7viVVLehMlVsQy8HEzY
	 FaeycKEJg+W3VzVFYkHKcWan2tsmMgYcdYltXGrc=
Date: Fri, 26 Jun 2026 10:37:55 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH 0/3] KVM: arm64: nv: Shadow ptdump fixes
Message-ID: <tl7vhu4wzqnptrfkl3bvvs5zc2ufcdhn5jwdav5hzve22hqcxq@zyu3drghk4sp>
References: <20260623142443.648972-1-weilin.chang@arm.com>
 <ajty6I7ZqodP4ous@sm-arm-grace07>
 <fabkknc7dqpve4oo2hsgcsodq4syfgg5bp54qi6cywzssaue7u@ow3q6tupzwyz>
 <86h5mrq71b.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86h5mrq71b.wl-maz@kernel.org>

On Thu, Jun 25, 2026 at 10:54:40AM +0100, Marc Zyngier wrote:
> On Thu, 25 Jun 2026 08:47:04 +0100,
> Wei-Lin Chang <weilin.chang@arm.com> wrote:
> > 
> > I don't see a way out with this per-mmu file scheme. The core issue is
> > mmus have a different lifetime than the VM's debugfs directory, and
> > both's removal can happen in parallel, i.e. the VM debugfs directory
> > can be removed anytime we are in mmu notifier release freeing the mmus
> > and their shadow ptdump files.
> 
> Why isn't that a problem with the existing S2 ptdump code?

For existing stuff, in terms of the ptdump files:

 - For the canonical s2, the ptdump files are only removed in
   kvm_destroy_vm_debugfs().

 - For nested s2, files are removed in two places: "manually" removed
   at mmu<->context unbind time in get_s2_mmu_nested() and in
   kvm_destroy_vm_debugfs(). get_s2_mmu_nested() is only called before
   kvm_destroy_vm_debugfs() of course.

So no dentry UAF in the current code.

Putting everything together, the situation is pretty complicated. The
canonical mmu, nested mmu, canonical mmu->pgt, nested mmu->pgt all have
different lifetimes, and kvm_destroy_vm_debugfs() can run in parallel
with mmu notifier release (like said above), which frees nested mmus and
canonical + nested pgts. Additionally, the .show() callback can be
called after mmu notifier release (Sashiko).

Now having thought about this again, per-mmu file can work, just defend
against freed mmu or pgt.

What I'm thinking now:
 - Just have all ptdump files removed at kvm_destroy_vm_debugfs(), to
   avoid accessing the dentry in mmu notifier release.
 - Revert effects of 204f7c018d76 ("KVM: arm64: ptdump: Make KVM ptdump
   code s2 mmu aware") because the mmu pointer stored in i_private and
   the ptdump state is simply invalid after mmu notifier release for
   nested.
 - Only store the kvm pointer in inode->i_private or seq_file->private.
 - For nested, check both mmu and mmu->pgt in .show() under the
   mmu_lock. For canonical only mmu->pgt check will be needed.
 - Guard nested_mmus freeing and setting nested_mmus = NULL with the
   mmu_lock so .show() won't have nested mmus disappear after checking
   nested_mmus exist.

I *think* this solves all problems known at the moment...

Thanks,
Wei-Lin Chang

> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
