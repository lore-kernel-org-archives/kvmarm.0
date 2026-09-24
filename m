Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDBE3CF1EF;
	Thu, 24 Sep 2026 17:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790272347; cv=none; b=n9QGv/3x1+1vDrYITzHCIauLbnr/bZ4+Rg6R3EtBm3TozmoOFUXyDtt/hrIycU+hPjDTNltnj0sNngpTFWOY9PTnarlVljnUoDVKDGei7IqIJp/QmTOcigjvCthRxD3YD+qewYrvaraIagyaHyk/HXvgjg7nFVJYoxnKYs23p4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790272347; c=relaxed/simple;
	bh=m+bgab+FjFF+c2EFlyl2oTf4LVO6kLp/oqnx1SkMatg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=slCiiBVLsjCDasf68MqyL2FocP//3HYp8k8qnGOFvdbdCIeMheRsKRdG7EXa2zFqRDjfvMI8Z9VoG0pH5mpoPcYcGA3DP+4ulbJSpaec00sR4Gn6VCQ064YO9USZsNcBFmZWhP4TurWn3+ffvZRlRBjBfwHWi+/y76db8Pw/ppU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WU0MPGxe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WU0MPGxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137991F000FF;
	Thu, 24 Sep 2026 17:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790272346;
	bh=m+bgab+FjFF+c2EFlyl2oTf4LVO6kLp/oqnx1SkMatg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WU0MPGxeb6eJeOi3UpyPQ0IPrZV93jy1SN/v4yJiWbjro47hht80E++aqsPdnLjgZ
	 GLhwvKvFNolQZDzbqGF8NZg7leDQmRR5sIXSXcv9+JIlMdpTBsSMIGJUNvFpfXPedx
	 QyJsmh20cMifuRiYvyigvOr7UxcelhbKv4HbeRxI497nhcJ12dzsdhs+cK71B2/yMt
	 scE6r2nPJkrGkROsGgyiss8o5esL4DjbIoWI4xIIu31JN2wZcaksBxTR3Dc4NsFUMV
	 V43HA0zSZH6pAaDG2PG/FoWxZTZTtvp9Ox3cYdj0HtlM316oq2QZP05AZM1h1MbYrM
	 0N1Xwz6G1O7zg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 21/22] KVM: selftests: Add find_bit to KVM library
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260924172928.2110956-22-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-22-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:52:25 +0000
Message-Id: <20260924175226.137991F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> Add lib/find_bit.c to the KVM selftests build using the same wrapper
> pattern as lib/rbtree.c so selftests that depend on find_bit helpers
> link cleanly when built standalone.
>=20
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D21

