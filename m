Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 128A540C03;
	Tue, 29 Apr 2025 15:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745939501; cv=none; b=IzQWdRqfjheR9uY92HCz0v2OLKsMHLpjVHYhYc7lC8J7e1LQKbNTnyh9pW/pGb5TlX1Qh0WZDYfq7gFicidMyTgi/dPj60U9rp+mYhkTZ+/+PctxBSDRW2kGFplMg0EudZ6mBO5nUdVnGGcVYnVyzGoRMkVvLZX5cFlDZyuPQ4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745939501; c=relaxed/simple;
	bh=Pw85bvKPW6geuN8xPdqHYexwbeo0OkIKHWasRYgOIos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZtVf+H0mcUEfzUSxpiIxy/94FOufDh7KdER/oAiDP9zI0YY28PufSpByAkxY3faU86xBCytZiAqCAwj2BhBZaB3w4LdhYIGkY291SW75A+kaT+7mPVpOxEPbC2yKqtlNwjwx8P2fB5Q7fD3nLPhFSeqrMYqMnyMQzeb4PnB/eac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YyyFw6Fs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YyyFw6Fs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C9CC4CEE3;
	Tue, 29 Apr 2025 15:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745939500;
	bh=Pw85bvKPW6geuN8xPdqHYexwbeo0OkIKHWasRYgOIos=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YyyFw6Fsm6++9CK1frNzVIQeOEQqqQqGbMpdcVzy3ZiWvSj93T5zhUQuNGaP2Unbq
	 Kyr3lY0lukc+qc2jlOuXRMp/e1XiVAoFVU3oVJssFGnFm6o4SgGbiBMftUAvEx7fUP
	 aEs+xutn42NvvkhDR6bI/GcvAnwBCOm7aXE+XleRacxH+hV3eg1AFCaza4Fl/VWe0q
	 twwTd67Li1d5nS1YL57uUJleMrBKtRDp6v4jkJNP8/diLI4NLQutyH2r/Bd1Gq6spQ
	 8GbklanWVi/bdStemi061oC8CSPyXGWNiT1rE57eEHc8gwBInWcQ/uEvsUrh6ZFpbZ
	 o6jLQ7+fmG4JA==
Date: Tue, 29 Apr 2025 16:11:36 +0100
From: Will Deacon <will@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Ryan Roberts <ryan.roberts@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] arm64/mm: Implement pte_po_index() for permission
 overlay index
Message-ID: <20250429151134.GB26272@willie-the-truck>
References: <20250415054442.2287891-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415054442.2287891-1-anshuman.khandual@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Apr 15, 2025 at 11:14:42AM +0530, Anshuman Khandual wrote:
> From: Ryan Roberts <ryan.roberts@arm.com>
> 
> Previously pte_access_permitted() used FIELD_GET() directly to retrieve
> the permission overlay index from the pte. However, FIELD_GET() doesn't
> work for 128 bit quanitites. Since we are about to add support for D128
> pgtables, let's create a specific helper, pte_po_index() which can do
> the required mask and shift regardless of the data type width.

You say:

"we are about to add support for D128 pgtables"

but all I've seen so far are piecemeal patches like this and it's hard
to know what to do with them, to be honest. Somebody could reasonably
turn up next week and clean this up to use FIELD_GET() again.

Grepping around, I also see that the KVM page-table code uses the FIELD_*
macros on page-table entries, so perhaps we're better off adding support
for 128-bit types to those instead of trying to avoid them?

Will
