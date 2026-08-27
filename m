Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62A643F4CD;
	Thu, 27 Aug 2026 10:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787826200; cv=none; b=g2+Ay2lvFdgarT79TLXTxyf1Qs5QeRQeA2Ju9jmDo3WHkcPHp/O6hkb62YYJkrpmfLy8YLcHrRTrdoVxA4H5ryJgcGze8rywh8xgIv27YbIsSxT4mGzPzPqKut5VwHnxXSqlcJ1/McuFIWRp+x5tFVsZNPYOrs/XOyrcgTdK7M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787826200; c=relaxed/simple;
	bh=gKvx6x6yFn1riKeJCsALS3iopPlz/iyt6AIIMRPHMfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ga6011hD+4vEHa8TgYZ3ty5Ae7FV7UfwDJaAoao/JGbH3qMYcY8zW3v0FT9q82Y44OCP/mZyq18v/mdmDjS3inaklBQjGZVBLIvgdzxgYcjbc63CATTyJ4ecOCEf0fsy8DaJ37gAEeYnXnJhZICyYI6CtUcE4E97rHKW0P3vcN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhfwHdHu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhfwHdHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F2E1F000E9;
	Thu, 27 Aug 2026 10:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787826193;
	bh=FWY53Qf1zP+pmrsD9SjCpbIZ8u4sT486ZmML1Qw8IO8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NhfwHdHuevu1f8nJG9q/cmu4j8w4IiklJkAXYq2k3PhC3cQ4h8CwlnClkjdmMk5Da
	 ogqv0P6x2h3cMjjMiQY2a1yqE0URXq6r1tSDQn2aGFUKIXz/Jml9CyU5lpEUI139WE
	 12ORae2fd5t5CXVTV0anCRIFuGJuYqEuqv4XLFX3EENvTp8/WmkvUE4jF5tDS7vNf9
	 w0o37XOjvF/dOnEZbhTPl37GFz0w+gTEwzVpizMyhv7hoT7T67jFSBKNVV9OJ7VV5q
	 fD/d+IOHPBWV6FrgWwUpFEzvq25lUbQOrG1nyLhZ5rJ9ZagBounLcY7yIvQYBFgYPl
	 D16VBtotIHTIw==
Date: Thu, 27 Aug 2026 11:23:08 +0100
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] arm64: Don't read GMID_EL1 when MTE is disabled
Message-ID: <apAQDInQK_hW90ZF@willie-the-truck>
References: <20260824184155.2644646-1-fuad.tabba@linux.dev>
 <aoypji6EJ8zToWvh@arm.com>
 <CA+EHjTwueqEAVq-7_ioRN+1h3LNPAqHX3rTqbXODViJJM-D_pQ@mail.gmail.com>
 <ao2jNDv8tOjnimEH@willie-the-truck>
 <CA+EHjTx93ERXZV1visdfBOGtH7wHff6TAoeJe+pNtikPrRp8Qw@mail.gmail.com>
 <ao7Isu9sxUEeECOZ@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao7Isu9sxUEeECOZ@arm.com>

On Wed, Aug 26, 2026 at 12:06:26PM +0100, Catalin Marinas wrote:
> On Tue, Aug 25, 2026 at 03:46:15PM +0100, Fuad Tabba wrote:
> > On Tue, 25 Aug 2026 at 15:14, Will Deacon <will@kernel.org> wrote:
> > ...
> > > > > If you are worried about additional trapping of the MRS, we should go
> > > > > for Will's improvement to always read the cached values in
> > > > > __read_sysreg_by_encoding().
> > > >
> > > > Not worried :) __cpuinfo_store_cpu() has already read ID_AA64PFR1_EL1
> > > > a few lines up.
> > >
> > > But if you go with __read_sysreg_by_encoding() then you'd still be
> > > reading it (and trapping) twice, no?
> > 
> > It would, and I'm fine with that on a CPU bring-up path.
> 
> For backports, yes. Going forward, I like Will's idea of reading the
> cached value in __read_sysreg_by_encoding().

I'll try to incorporate that on the end of my parallel hotplug series,
which I intend to post next week. I just need to untangle the mpam stuff,
as it populates the cpuinfo structure far too late.

Will
