Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263F0802;
	Mon, 24 Feb 2025 09:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740390293; cv=none; b=VbcIPNK/tEa28mG2GXQOB8RGTjM6VoE9I/DK2zDlwWWrT0kGQWy1S+JkfzGE01prgho4byz+r18hmQ8Lt3nvXHZaPjXQyWXx+NJjdrz1tHeTw/TCHHg5eQDx5RFK64aOuK4lVmXJDRlTSk7S+Wpq9fB14kj0feCXlWaEyjUWNjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740390293; c=relaxed/simple;
	bh=Oy30/9mZEn7bUDinnc0MnPc95uAajJprYdB66FJ2hCs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GHLJBhk+WNbCmw5lwgjhhtV57VWcszFS3GRN8dL501RjhlkoOxK/BVn0zd1484gcusjr19jsxKjwHykaI87hdyf8kwL6bRVRwF1AByGdI0p6AkHvYEk1AwpNnN6axg9E8Pf3SF/PNQuJgvM65QQ/wM5RUaH52EVjRvNPGu6XvAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZzRW7iYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZzRW7iYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70987C4CED6;
	Mon, 24 Feb 2025 09:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740390291;
	bh=Oy30/9mZEn7bUDinnc0MnPc95uAajJprYdB66FJ2hCs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ZzRW7iYPehAt4rl2l5x8kO9GrbI3DA+cEo6LuHgroln05qBr+x3k7Iu+UBZtGq6CJ
	 NZjxXQYOU1LX19IF0G7wVIBzhlGfaJggIV2co5mGNCNC4TYP13qC0dpsq3d72P0sAt
	 ziVbsWv3TTPCoAVh1dNAet91w8X01FmFm3Hu32FXF7BznloWziRPwM6MCg6iEaybaM
	 s5KVkJ/joeYbskA8UNWDmcxzv3j+PDdsNmXqS8QlVieRqFb2X6PlSjArl5HEiM5xtd
	 Vka1QE1vNd1iIusYL8J1TWHGVReDLPEnl8CRuIUJsG7Jt3Ezt0BwkAMtPLiVdgiIC+
	 hOGNJku6qPvBg==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	gankulkarni@os.amperecomputing.com
Subject: Re: [PATCH v2 10/14] KVM: arm64: Allow userspace to limit NV
 support to nVHE
In-Reply-To: <20250220134907.554085-11-maz@kernel.org>
References: <20250220134907.554085-1-maz@kernel.org>
 <20250220134907.554085-11-maz@kernel.org>
Date: Mon, 24 Feb 2025 15:14:44 +0530
Message-ID: <yq5a4j0jhe2b.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Marc Zyngier <maz@kernel.org> writes:

> NV is hard. No kidding.
>
> In order to make things simpler, we have established that NV would
> support two mutually exclusive configurations:
>
> - VHE-only, and supporting recursive virtualisation
>
> - mVHE-only, and not supporting recursive virtualisation
>

mVHE-only -> nVHE-only 

-aneesh
