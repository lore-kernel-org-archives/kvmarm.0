Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACA719EEAA;
	Thu, 15 Aug 2024 12:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723725998; cv=none; b=GnbFowSK1WDR5TpD+gGO6tNwV3ovxujZmYY8fBemhVsThkmSTIYnAaAAi+kTX4N8Wq2deipIMBwZgiDESSwHH2qec1t3YEGG9HeJtPJHqyqiwqlW/WyXVo4PEO3HWokBjzoAyFGsDHhRVO8E+fTKCyWxh7k6iRYjPplyl5ZmjK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723725998; c=relaxed/simple;
	bh=oym3xrzvlJUjx++l2BmytpxCZJiZTAUsK4KL7PjCtMQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PRiKmDSnR+Ywuh/2js+pkqgw/dS8BWAohOAwlK28XDrIhV+v1pp4Up88klq0GsL/nlZYvdY6EKffNSUuXzr/T58lIW0r+gcUzUWMm9QNvZBLWAVK3KXCz9uXUOrtyQ4+rqqeZmeb/4oVBDmEN2gT4s1qUh0iW6UeAS5l037NZao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qY/mmL6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qY/mmL6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA04BC4AF0A;
	Thu, 15 Aug 2024 12:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723725997;
	bh=oym3xrzvlJUjx++l2BmytpxCZJiZTAUsK4KL7PjCtMQ=;
	h=From:To:Cc:Subject:Date:From;
	b=qY/mmL6S56OfH/L3cvv06bVFWqUhoGn8aU3rHIMkD/kyVqhGz4BL8R8vpAiYQaU1u
	 bNbpHxUwka6E33XgLPZk+allMTxXDUBoNOVO9xT/mxvrZ2IrQn2ieLaPz02SENoJTQ
	 6vVVX8Wd1TA9CCo8j+4WoYyslRrhBVqXfLxHLTZbB809oaSqYNfXcW4SjLmVRblyWX
	 2SnC9Rx6V/Y4jegFu0szu74CFC9wxecPuPULzIfBCAcj+c+/SO3lz+eaQPrdPc3ghw
	 z4qlysmaVXaP04/WaIequZ81hjzqRmZajofZLh+Mm4vbDZtd3xb66cLXr3epi9mzGi
	 B7dDmcOe7LIkQ==
From: Will Deacon <will@kernel.org>
To: stable@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Subject: [PATCH 6.6.y 0/2] KVM pgtable fixes
Date: Thu, 15 Aug 2024 13:46:24 +0100
Message-Id: <20240815124626.21674-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi stable folks,

I noticed that these two KVM/arm64 pgtable fixes are missing from 6.6.y
so I've done the backports. The second one is also needed in 6.1.y but
it needs some tweaks so I'll post a separate backport for that.

Cheers,

Will

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
cc: kvmarm@lists.linux.dev

--->8

Will Deacon (2):
  KVM: arm64: Don't defer TLB invalidation when zapping table entries
  KVM: arm64: Don't pass a TLBI level hint when zapping table entries

 arch/arm64/kvm/hyp/pgtable.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

-- 
2.46.0.184.g6999bdac58-goog

