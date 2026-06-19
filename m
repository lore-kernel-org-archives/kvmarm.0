Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335655477E
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 14:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781878794; cv=none; b=Kas6fF49c9lQts2eZ1eFCvk1VygTIuNpBBLy061TMiZrj/fLCkWEZH3W3fyun+00u/tGldO9CkYNf4nBcekwCiHU74pF4pOBoWIHWaktrjxe1aw0/mRCgTdx4yw7HKuXXRGYbRNLZsKwqXXU+TjWYV0L1GMB6g8/5KGwbGa6I/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781878794; c=relaxed/simple;
	bh=7p8ccJFoWHNBLQHrv3+QdmZxJ20JsMfGm2JqKC3h5kM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=PjIEVOPeGLAuZoJ3agU5vwI1S64IMNx6As8P+e+cqceUS8spsHd4e/GGeZf+wShtmc8Q0XsfVDSai8evTbcZcZlyTsyk7+4Z6X8DSoay2C5NG+bVBwmaENP7t7833qvNtDrDlqesLLGsDqbyQc1lOR04UGJKgM0+UO7m/dc0MAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bpg/mWl3; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bpg/mWl3"
X-Forwarded-Encrypted: i=1; AFNElJ8ie2306gipmJE+gomVC3at4bFC3oBWlQjBD49LG2vLyeLyn7nUIxECVZ2UX7bWEMQdI5O5auo=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781878789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=wQ4Ng+LzyP6Ck70/q0BOXIvLcZSpukBiRvm7qyJ1pRA=;
	b=Bpg/mWl3lgQK03w4xBg9NnhICSauuJk6CaPyZMNmLQrWnAPEAFgyXV+F3obR4StQrEBhnP
	NLOXjDmG/zMEQ21d7i6SnjCbpFsC3HZWsky7XA6dBuxncoYukmnQKtBoJj314Br3NMLmcW
	MAcrufNgAfQrIGGj52pGg7imxgkuPBI=
X-Gm-Message-State: AOJu0Yw/3NG8Ks/Ii3WzN8G2SeoeRdJPlye5y43yUVMOzwTiGm8f7y+P
	rOlkBlmZKCqG6+MptKtsmGipSMqgN3NRgVLjnRU8NwY97C0mE6pNOzrBt14P2wfeL0W4wTCYq9O
	1BqQ1br2/L/2JhrRLWp4jkhGmGBEM1C1bL1/USAyM
X-Received: by 2002:ac8:570d:0:b0:516:4f62:85ee with SMTP id
 d75a77b69052e-519e8d36342mr7828541cf.19.1781878782147; Fri, 19 Jun 2026
 07:19:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 19 Jun 2026 15:19:05 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzdCf2waY_Qc+GWzA-MuKG=_XjQ4Hzn3HJ6Yi0NfB_CzQ@mail.gmail.com>
X-Gm-Features: AVVi8Ce6d39_roogfjXkWcCH8jzZ67wd_hkYDt1SAHxCyG96Th0pYt5NLuptnw0
Message-ID: <CA+EHjTzdCf2waY_Qc+GWzA-MuKG=_XjQ4Hzn3HJ6Yi0NfB_CzQ@mail.gmail.com>
Subject: Sashiko review emails to the list
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Will Deacon <will@kernel.org>, 
	Vincent Donnefort <vdonnefort@google.com>, KVMARM <kvmarm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi folks,

I really like Sashiko and find it very useful. It's flagged real bugs
in series I and others have posted to the list (e.g. [1][2][3]), and I
run it locally before sending, which has saved me a few respins.

That said, it's been posting a lot lately, so it seemed worth asking
how the review emails to the list are working out, and whether we
should change anything.

A couple of things stand out:

  1. The noise. Some is genuine false positives, where the model
confabulates ARM details (bit positions, ISS field layouts, and the
like) and flags correct code [4]. The rest is repetition: the same
finding posted against several patches in one series, often a real
issue not introduced by the series.

  2. The emails themselves. Mailing review to the list automatically
can push contributors to respin many times chasing bot comments before
a human's looked, and pull reviewer attention onto findings that may
be misguided to begin with.

On the noise (1):

  - From the logs it looks like Roman's been working on the
false-positive detection on GitHub [5], and the rate's dropped
noticeably in my local testing. I'm not sure the list version has
those changes yet (I get different results locally, fewer FPs), and he
told me yesterday (offlist) he's working on the repetition too.

  - I've been working on the arm64 prompts to stop the confabulation:
the model doesn't have the ARM ARM, so it hallucinates encodings and
asserts them as bugs. I submitted a PR to review-prompt [6], which
should cover most of these but not all. Longer term I have a local
prototype that gives it the actual spec text, but there are copyright
questions around shipping it. I've offered to share it with Roman,
minus the copyrighted material, to see whether it's something we could
use and extend, including to other architectures.

These only address (1). The second concern stands regardless of
accuracy, since it's about respinning before a human's looked, not
whether the comments are right.

These fixes will take a while to land, so the question is what to do
meanwhile. Some options, and surely others:

  - Leave it as-is while the fixes propagate.
  - Stop the emails but keep the reviews on sashiko.dev, so people can
look rather than have them pushed.
  - Disable the emails until the noise is down to a reasonable level,
then re-enable.
  - Raise the confidence bar so it only emails high-confidence findings.

This seemed worth discussing on the usual lists rather than on GitHub,
which has less visibility. What do you think?

Cheers,
/fuad

[1] https://lore.kernel.org/all/CA+EHjTxLVo=GwderoFxqsOEFXV+DrD17nQCkPbnKZPA6mRNxhg@mail.gmail.com/
[2] https://lore.kernel.org/all/20260612113414.1022901-1-tabba@google.com/
[3] https://lore.kernel.org/all/20260615131116.390977-1-tabba@google.com/
[4] https://sashiko.dev/#/patchset/20260619070719.812227-1-tabba@google.com?part=7
[5] https://github.com/sashiko-dev/
[6] https://github.com/masoncl/review-prompts/pull/81
