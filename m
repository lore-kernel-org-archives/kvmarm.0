Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A6720E011;
	Fri,  9 May 2025 15:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746802959; cv=none; b=ebSnHexqAUDpZL8M8SHR8MwaoPz7KusOltCbG104JtD0VcI72H1e+xdvO52RnxQ0MPfRza9sPXoP2AWxEPTvuzUvQGy9JL0qM7JLvOdrMWxDoeql4AmazJlOBHr3VxTwqJ3Mgw+KeSlkwmAAta1wfLZwBtutfc1W2JVxvJwn7f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746802959; c=relaxed/simple;
	bh=7NskiScE5gptOGADrQReISR757xZmSnWMX0UyKOeZCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ho6VZkvSiOzq9p5BW3NCEsplmQAb7tk8JhOxVHK/GUU7EnjymXn+nPXhXe3PIuBVqrXqKPoJXw5al/zALlLecoo/pxY1PVugwjUI5NN+pLeZwe/C/kEbL8NeREGHHFm/e/AeambI71rB+BeyZWHGijhUIKOH8sft6ih+8wlnL58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZWQzY+hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZWQzY+hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38004C4CEE4;
	Fri,  9 May 2025 15:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746802958;
	bh=7NskiScE5gptOGADrQReISR757xZmSnWMX0UyKOeZCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZWQzY+hvdRs9Re4KDHntxug0qY5Ca7OwjjFfM2Dn7yZOCj6QK6lIfaqvNMQ4OIo3d
	 w87JJHVlm/5gF48Ytqb2lav051IsEnhc0mUdBnQG6VIWR/VBplOAZMLSIwVXaYDfBq
	 J5W1U8D2EqfTJkZrlE5RnxyNH+lAWNBi5l7k4NQxZ2njHf983SifjFK6mlksmZ+RS2
	 zTf8bJBT/+oCJt6zumU+GZxluzCGzPuCI0hcWgf/2GQjTGibVLVWYs2AckrZNWPW4r
	 lgoCSsj8pLyGn9/krfB6WCElwvcIeO8tY8PCJUuhrRM9NsiX1TO7NmGh472rnvCfrO
	 /JKGE0GOhqOBA==
Date: Fri, 9 May 2025 16:02:33 +0100
From: Will Deacon <will@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] arm64/mm: Implement pte_po_index() for permission
 overlay index
Message-ID: <20250509150232.GA5984@willie-the-truck>
References: <20250415054442.2287891-1-anshuman.khandual@arm.com>
 <20250429151134.GB26272@willie-the-truck>
 <b07c1320-3140-40d3-899b-7c2b6e0d3c18@arm.com>
 <16ffa9f2-5ebb-4839-ab87-3c193ab9683a@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16ffa9f2-5ebb-4839-ab87-3c193ab9683a@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, May 05, 2025 at 02:20:46PM +0530, Anshuman Khandual wrote:
> 
> 
> On 4/29/25 22:15, Ryan Roberts wrote:
> > On 29/04/2025 16:11, Will Deacon wrote:
> >> On Tue, Apr 15, 2025 at 11:14:42AM +0530, Anshuman Khandual wrote:
> >>> From: Ryan Roberts <ryan.roberts@arm.com>
> >>>
> >>> Previously pte_access_permitted() used FIELD_GET() directly to retrieve
> >>> the permission overlay index from the pte. However, FIELD_GET() doesn't
> >>> work for 128 bit quanitites. Since we are about to add support for D128
> >>> pgtables, let's create a specific helper, pte_po_index() which can do
> >>> the required mask and shift regardless of the data type width.
> >>
> >> You say:
> >>
> >> "we are about to add support for D128 pgtables"
> > 
> > Providing some context: Anshuman has a private branch that adds D128 pgtable
> > support to the kernel (it does not yet do this for KVM). I originally created
> > this patch to fix a bug on that branch, so the "we are about to add ..." comment
> > really only makes sense in that context.
> > 
> > We are not yet ready to post D128 upstream - there are still a lot of questions
> > to answer - but Anshuman has been posting some of the reshuffling and cleanups
> > that prepare the way for D128 where (we think) it makes sense. The aim is to
> > reduce the diff as much as we can.
> 
> Agreed. All these patches have been really harmless clean ups and re-orgs etc,
> that do not affect existing 64 bit page table management or its functioning in
> any manner. OTOH these changes help the kernel prepare for D128 enablement.

In this case, I wouldn't call it harmless clean-up. You're actively
removing the use of helper macros which is inevitably going to result in
churn.

Please teach FIELD_GET() to work with 128-bit types instead.

Will
