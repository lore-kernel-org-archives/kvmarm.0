Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907B85D8F0
	for <kvmarm@lists.linux.dev>; Sun, 13 Jul 2025 11:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752405971; cv=none; b=TYA01C6fLozt1bncqjVTb9eAhYZHArEtXeivdtIBpKlo17u+dTYSQF3OEb92tLCZxfB4uPw3nb+gcQTGE0r7E5uQaCkV0eQZWWVQ/wLp/u7mpxu8jD8uiTXJTECjYCY9adiW3eHvkiEL2z2NBISt8Cyj4hQ9JgX/9N5C72fFL+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752405971; c=relaxed/simple;
	bh=c3Q8QEGiOg6VqtKooLbYt69TTUZ6bQSCAr/wJwfz/lw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GCJ+Irx/huHjL4Ydz0Fi4HF476VTtiY+yifcT0hdjvR3mgPlKha/FaU+Wja6mDoFeqX7cmcHAxg0NXtSRsW5wq0vuk4YApv3dZ1rTGycD3kxbFlfF9iA9X0pPpqFAT/KM7UrJg9fdv3/9LY2SA4WVlLxDYVlXTSHC3LbmQP59TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QemZ5N3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QemZ5N3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F75C4CEE3;
	Sun, 13 Jul 2025 11:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752405971;
	bh=c3Q8QEGiOg6VqtKooLbYt69TTUZ6bQSCAr/wJwfz/lw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QemZ5N3ij1UawecXNKJxgZVK7pgLRbRPSPE+D1jjtWX6o/7sTrYM8AaA/UP1FZ0nt
	 d/q4KZv7KCLEgAahvbj89D3L7lQytAFlTXfaSrwJT0AlZr6bfMP9SXQjRINPXsbQWw
	 f70hLEwThDFWKHbBo12MsMj7K0M6sgzMMeBoiDt6bJDZ3RjFVV7VoQpGEup6j6QobC
	 9cQVoflt7qPxyLiGI7y7UH7n3rero7ecIsvgACJOfe4xWF0fcYwOfqZpqs3om8tEQX
	 HQY8W0OYzuA/xySO3GW20m2ruYvuPzubFTgye/UadvBjSLy/+pHZHf3SkGcP95dATa
	 7/dIv/E69ZMsA==
Date: Sun, 13 Jul 2025 12:26:05 +0100
From: Will Deacon <will@kernel.org>
To: DaeRo Lee <skseofh@gmail.com>
Cc: alexandru.elisei@arm.com, james.morse@arm.com, kernel-team@android.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	sebastianene@google.com, sudeep.holla@arm.com,
	suzuki.poulose@arm.com, tabba@google.com
Subject: Re: [PATCH v3 08/10] KVM: arm64: Handle FFA_MEM_LEND calls from the
 host
Message-ID: <aHOXzUvGaQ1Bz3jG@willie-the-truck>
References: <CAATEi5=y6w3jziwKbrnUkWGy=RTGh=+jKdrXEnOdAiEcH=npOQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAATEi5=y6w3jziwKbrnUkWGy=RTGh=+jKdrXEnOdAiEcH=npOQ@mail.gmail.com>

On Sat, Jul 12, 2025 at 10:36:24PM +0900, DaeRo Lee wrote:
> > Handle FFA_MEM_LEND calls from the host by treating them identically to
> > FFA_MEM_SHARE calls for the purposes of the host stage-2 page-table, but
> > forwarding on the original request to EL3.
> 
> I have a question about your patch.
> Does treating FFA_MEM_LEND as identical to FFA_MEM_SHARE imply that
> the host can still access the memory even after it has been lent?

Only if your TZ implementation is broken and relies on the NS hypervisor
for isolation.

Will
