Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69EB204F60
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 10:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730112830; cv=none; b=eesF9cj4aWjsCY60UrvQEi52P4JuGZBRNaOHJcTPGUmlvpTI0c7bAzXGHKD4sXNyS48Q9ZLqvJ6c0Jo0Zs5THeGRk5VTRBi6eft1EQy/SPKns4VUrTSINUgdVZXMAkM9q6yDh6TIjyS8c/lh864ObXuLUKCRl8myVWnGBMpe6SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730112830; c=relaxed/simple;
	bh=etuJv7VN1Rzoyh2Pz9FpTtPKX14gyYSQIP4BK59zGFo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZLkymzUvzTgjmyH/NIKiEPjjtyXA2HwBQM9HoAmCUnuuRnx1Aed+K1prlsykElVjGHkLpM39Gr+FvQsll/qRGfJZA3V5pv6ZS5X9KpBTny35mrGpUWRJjyIDPasEzCTO9dDVrVGq/tBZPqTtDWGYsMQkdoNZvJYP2LQ8Gamguvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sgzjd9JH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sgzjd9JH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAE3C4CEC3;
	Mon, 28 Oct 2024 10:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730112830;
	bh=etuJv7VN1Rzoyh2Pz9FpTtPKX14gyYSQIP4BK59zGFo=;
	h=From:To:Cc:Subject:Date:From;
	b=sgzjd9JHnH1rX1/B0TEqBvuW1gcqUTCwY+vitLAdTKQyyCChEmboFJ8huUl8x/qJv
	 r8U+YRgXJ66+dyH2p4VGekHSs0UaRDjGf+RBc+ZPgVv8mUTmpmWNgejT9389n2+G0c
	 jrf5e8V3Zsm78rXR0cpFBCwtiJ5fBxaNegQSHt7vq9t5KEO54RX9s/rWWqBXDGAZ/w
	 +To5M7vkiGGV2w6iK9U315gdUQTGQvIbuU7Fq1ehcwhdl+nWMP/Cq2WbCWMnz3CCEj
	 L/MnNxIP3yQTr1bgxWJ/GwusbY0J5Ew3dA11sQQe+R+Y9/ZH4CYLaabqxFeFDb2sCd
	 xXQqX8vhNJuUg==
From: puranjay@kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <maz@kernel.org>, "Arnd
 Bergmann" <arnd@kernel.org>, =?utf-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, Sumit Garg
 <sumit.garg@linaro.org>
Cc: puranjay12@gmail.com
Subject: Supporting KVM_GUESTDBG_BLOCKIRQ or something similar on ARM64
Date: Mon, 28 Oct 2024 10:53:34 +0000
Message-ID: <mb61p4j4wwlap.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain


Hi Everyone,

I work on the BPF JIT for arm64 and regularly use Qemu with gdb for
debugging by single stepping parts of the code. I realized that whenever
I enable KVM, single stepping doesn't work as expected and it lands in an
interrupt handler.

It always worked for me on x86 so I looked in the source code and found
that x86 supports KVM_GUESTDBG_BLOCKIRQ that blocks IRQs when single
stepping.

I assume that arm64 doesn't support KVM_GUESTDBG_BLOCKIRQ because it is
not trivial to implement this on arm64 due to some architectural
limitations? There was a patch [1] posted in 2022 to solve this issue
but it was not merged.

Let's start a discussion about what needs to be done to support this on
arm64.

Thanks,
Puranjay

[1] https://lore.kernel.org/lkml/20221219102452.2860088-2-sumit.garg@linaro.org/

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iIoEARYKADIWIQQ3wHGvVs/5bdl78BKwwPkjG3B2nQUCZx9tMBQccHVyYW5qYXlA
a2VybmVsLm9yZwAKCRCwwPkjG3B2nf8pAP0Z4l83ZysYTSxJ+Yx1tDM5p5iqe7sb
sHTd8cxXSmY7wAEA7XIBZjFQpUNqB4bRQSPm8hHZAQg8Ckd/fVQVdfsSuAA=
=ZEKp
-----END PGP SIGNATURE-----
--=-=-=--
