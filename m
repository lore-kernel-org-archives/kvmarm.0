Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9495537B3FD
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 18:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781892386; cv=none; b=N1+V/IPL9fkSd4lxHYQ7gOQ0MS6R5nrXua9zf0cqvi9OveZBjo10PDge//SIzGTMIdlvhy4bgj8gl6VNdXKO+pNgcF9i4KNfuqURvAhPyrrOHPMdkMWJ7QAlq2EFKwxiMPqGZB9ab2Nhh4AeMgzsvN4L99ossdssTIrSvbnwKRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781892386; c=relaxed/simple;
	bh=6lvvhnuNTKGj48jzaIIv5l29AA6xz1VMSl8FGg5mgqc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=RnBAnhcvDRBLSyY8UYn9Y/JU0+KPmdxS0qtOXFfG/vP50R2rK6LBIlbWfsy6No5yWuLC2jgyVFEPZp/XqDTMSzFS+0klIjYm4xV+PpCBo8v+pLk3PoIanzmfh+hlqLWRUKrd2QLim5pZq1iHGqA1g45HVca84fZ+f3dLOA+ThpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VD2k9uwa; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VD2k9uwa"
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781892381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=naQXODHS49rdGL/7n2M4vWRMO8A2UL8DQ8EBSaNzmA0=;
	b=VD2k9uway8LbnB1UvlSD3lHTiGs1WEE9N/eQzn8mNhIowZjNB3lBHDw/acePzwumDcU5sT
	+Kg5h/a96xpQYPbXEcboTduBfooXHx9w+md8wRTumw5HisI4+ip9CgVHjmyHWLg+SsmWyp
	hO1xvaAEb1vgaQlSffVK0P5JGDcAdL0=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: Sashiko review emails to the list
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
In-Reply-To: <ajVyJa-mZmYGzt6o@kernel.org>
Date: Fri, 19 Jun 2026 11:05:57 -0700
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>,
 KVMARM <kvmarm@lists.linux.dev>
Message-Id: <7A91E52F-FCF3-4BB5-8AE5-9ED3A43809A8@linux.dev>
References: <ajVyJa-mZmYGzt6o@kernel.org>
To: Oliver Upton <oupton@kernel.org>
X-Migadu-Flow: FLOW_OUT


> On Jun 19, 2026, at 9:45=E2=80=AFAM, Oliver Upton <oupton@kernel.org> wrot=
e:
>=20
> =EF=BB=BFHey,
>=20
>> On Fri, Jun 19, 2026 at 03:19:05PM +0100, Fuad Tabba wrote:
>> Hi folks,
>>=20
>> I really like Sashiko and find it very useful. It's flagged real bugs
>> in series I and others have posted to the list (e.g. [1][2][3]), and I
>> run it locally before sending, which has saved me a few respins.
>>=20
>> That said, it's been posting a lot lately, so it seemed worth asking
>> how the review emails to the list are working out, and whether we
>> should change anything.
>=20
> So this is entirely my fault since I added the email configuration for
> the kvmarm list. Sashiko has been finding some truly nasty bugs, posting
> on-list is the easiest way to get attention from the right folks to get
> things fixed.
>=20
> With that being said, the signal to noise ratio hasn't been ideal.
>=20
>> These fixes will take a while to land, so the question is what to do
>> meanwhile. Some options, and surely others:
>>=20
>>  - Leave it as-is while the fixes propagate.
>>  - Stop the emails but keep the reviews on sashiko.dev, so people can
>> look rather than have them pushed.
>>  - Disable the emails until the noise is down to a reasonable level,
>> then re-enable.
>=20
> This sounds like the right approach. I'd like to re-enable emails once
> we're happy with the quality of reviews.

=46rom my perspective there are 3 main factors affecting the quality of revi=
ews:
1) llm model capabilities. we have little control here, but it=E2=80=99s rea=
sonable to expect that things will get better.
2) sashiko=E2=80=99s common code/harness. we=E2=80=99re improving it, but I=E2=
=80=99m not sure we have a lot of room left here, probably some. also, there=
 are many tradeoffs to make, e.g. if we start verifying each issue separatel=
y, it almost certainly will improve signal/noise, but it will require way mo=
re tokens and will be slower.
3) developing per-subsystem prompts. there is a lot of potential here, but t=
his is where we mostly rely on maintainers and developers.

Also not trying to push back on the decision, but I think it=E2=80=99s worth=
 asking what is a reasonable level?
I tried to measure the true positive rate several times based on human feedb=
ack and it always was at least ~80% (and usually more for critical/high seve=
rity bugs).
And I=E2=80=99m afraid that it won=E2=80=99t be ~100% without compromising o=
n the ability to find bugs. The reality is that there is a significant perce=
ntage of issues which are not exactly black and white and even people don=E2=
=80=99t necessarily agree if it=E2=80=99s an issue or not. Also there is a n=
on-trivial amount of cases when ai findings are incorrectly dismissed by hum=
ans.

I=E2=80=99m not trying to pretend it=E2=80=99s perfect (it=E2=80=99s not), a=
nd I certainly expect it to be better going forward (and I=E2=80=99m working=
 on it),
but the point is that we might not see _dramatic_ improvements going forward=
 simple because there is no room left for it,
it=E2=80=99s more like a long tail of grey zone issues.

> On another note: Roman, is it possible to separately report pre-existing
> issues from findings in a patch? Maintainers have a higher likelihood of
> caring about these than individual contributors anyway.

It=E2=80=99s certainly possible, but how exactly do you see it?

It=E2=80=99s already somewhat separated (separate counters, separate list on=
 top of each email).
I don=E2=80=99t want to stop reporting them completely (but we can discuss i=
t), because it produces
a constant stream of fixes in the upstream kernel (in hundreds already).

I plan to improve it to e.g. not report multiple times within the same patch=
set.

Thanks=
