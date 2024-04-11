Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84B51BC5C
	for <kvmarm@lists.linux.dev>; Mon, 15 Apr 2024 03:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713153182; cv=none; b=tKKx09cXzcKGLVnKCAdhmhYT47Dm03y0wIxXY3pDw1SSvkj5fYpQPkWyfrb3rggqVj0BRaosnV1dhRObAS6Pjdg23Fum8oT2zmcvFGOgiZ4t2DDAK9QpTRscT1jBk3QKZldCh+PsJCssvCwou5pFc01d5gtRAGkFyPTaAWyD6Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713153182; c=relaxed/simple;
	bh=ergepOHk2Up2F+K2BlRT3j6+Mi33g2JFoZO9J6zxBhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PiniUIlpfnPqTxNJbVinN9KFI1kyiVPlI1OORv7vGtpgtYfWCySj/+cKuuPjrdsY+XPNHUNZjBh26vW5Q+vMgJKHWtHEznrtlmYPHQ/x1WbwExSY7N48SlQ8AACzMC/zlYIY85dEFiYF4M9e2/lpdrrK1l7Z6eXrUa6kBU7yWxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TkkCWgG9; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TkkCWgG9"
Date: Fri, 12 Apr 2024 03:54:12 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713153178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sp9uhHvSslbHFr0rV64RPlTRaApRy5n5koOI6A6IDog=;
	b=TkkCWgG9peqecfy6NrOEHHcavSOBgxVDo+CQStt76qokqk/hP9jC0Xj9e9xA4CwZmdARvO
	4Hx0GSDLANCphBT9s8H5rv4I4lEvb7/2ajvk2a2hZxNbPH7itzOmmKZYMtVJAiBYpNlrEe
	Lk4bTeCdzAHLMFKQVUi9QJNdB8BRwws=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [v2] Support for Arm CCA VMs on Linux
Message-ID: <Zhgx1IDhEYo27OAR@vm3>
References: <20240412084056.1733704-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412084056.1733704-1-steven.price@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Steven,

On Fri, Apr 12, 2024 at 09:40:56AM +0100, Steven Price wrote:
> We are happy to announce the second version of the Arm Confidential
> Compute Architecture (CCA) support for the Linux stack. The intention is
> to seek early feedback in the following areas:
>  * KVM integration of the Arm CCA;
>  * KVM UABI for managing the Realms, seeking to generalise the
>    operations where possible with other Confidential Compute solutions;
>  * Linux Guest support for Realms.
> 
> See the previous RFC[1] for a more detailed overview of Arm's CCA
> solution, or visible the Arm CCA Landing page[2].
> 
> This series is based on the final RMM v1.0 (EAC5) specification[3].

It's great to see the updated "V2" series. Since you said you like
"early" feedback on V2, does that mean it's likely to be followed by
V3 and V4, anticipating large code-base changes from the current form
(V2)? Do you have a rough timeframe to make this Arm CCA support landed
in mainline? Do you Arm folk expect this is going to be a multiple-year 
long project? 

Thanks,
Itaru.

> 
> Quick-start guide
> =================
> 
> The easiest way of getting started with the stack is by using
> Shrinkwrap[4]. Currently Shrinkwrap has a configuration for the initial
> v1.0-EAC5 release[5], so the following overlay needs to be applied to
> the standard 'cca-3world.yaml' file. Note that the 'rmm' component needs
> updating to 'main' because there are fixes that are needed and are not
> yet in a tagged release. The following will create an overlay file and
> build a working environment:
> 
> cat<<EOT >cca-v2.yaml
> build:
>   linux:
>     repo:
>       revision: cca-full/v2
>   kvmtool:
>     repo:
>       kvmtool:
>         revision: cca/v2
>   rmm:
>     repo:
>       revision: main
>   kvm-unit-tests:
>     repo:
>       revision: cca/v2
> EOT
> 
> shrinkwrap build cca-3world.yaml --overlay buildroot.yaml --btvar GUEST_ROOTFS='${artifact:BUILDROOT}' --overlay cca-v2.yaml
> 
> You will then want to modify the 'guest-disk.img' to include the files
> necessary for the realm guest (see the documentation in cca-3world.yaml
> for details of other options):
> 
>   cd ~/.shrinkwrap/package/cca-3world
>   /sbin/e2fsck -fp rootfs.ext2 
>   /sbin/resize2fs rootfs.ext2 256M
>   mkdir mnt
>   sudo mount rootfs.ext2 mnt/
>   sudo mkdir mnt/cca
>   sudo cp guest-disk.img KVMTOOL_EFI.fd lkvm Image mnt/cca/
>   sudo umount mnt 
>   rmdir mnt/
> 
> Finally you can run the FVP with the host:
> 
>   shrinkwrap run cca-3world.yaml --rtvar ROOTFS=$HOME/.shrinkwrap/package/cca-3world/rootfs.ext2
> 
> And once the host kernel has booted, login (user name 'root') and start
> a realm guest:
> 
>   cd /cca
>   ./lkvm run --realm --restricted_mem -c 2 -m 256 -k Image -p earlycon
> 
> Be patient and you should end up in a realm guest with the host's
> filesystem mounted via p9.
> 
> It's also possible to use EFI within the realm guest, again see
> cca-3world.yaml within Shrinkwrap for more details.
> 
> An branch of kvm-unit-tests including realm-specific tests is provided
> here:
>   https://gitlab.arm.com/linux-arm/kvm-unit-tests-cca/-/tree/cca/v2
> 
> [1] Previous RFC
>     https://lore.kernel.org/r/20230127112248.136810-1-suzuki.poulose%40arm.com
> [2] Arm CCA Landing page (See Key Resources section for various documentation)
>     https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
> [3] RMM v1.0-EAC5 specification
>     https://developer.arm.com/documentation/den0137/1-0eac5/
> [4] Shrinkwrap
>     https://git.gitlab.arm.com/tooling/shrinkwrap
> [5] Linux support for Arm CCA RMM v1.0-EAC5
>     https://lore.kernel.org/r/fb259449-026e-4083-a02b-f8a4ebea1f87%40arm.com
