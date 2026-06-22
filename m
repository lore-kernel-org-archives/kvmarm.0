Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D330283FE6
	for <kvmarm@lists.linux.dev>; Mon, 22 Jun 2026 19:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782156064; cv=none; b=rtfwifjTLlmyLNwjdkQy1jxLbgBv+q2V+64a+8mygqKNsLTAJT/KkkWSKYJO+T7/RRuFmX9HTbCVVQ1tVRecaa1qF9Ut14KWbXTR/labX8GFETLATlqUr+bJn9EmNmOv6oJPuH6qqkqVxo1Yt/h+Ja4rKvMnqlwNXErMi1jtQ1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782156064; c=relaxed/simple;
	bh=yYfFsnpbroLaEhyucoJypWm8v4a6TEOgyaGRt3YJf+M=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Rmqp3WgagadHy93x0ILHaVHSqIcsuqp8RL0iYCEIUUuPur1hB84snxxXEdWrdMv56AB6Yh7//Bcl9+SOz91Gi8haGdHgE/jENthlNbILjvd5Hurobgf2TxjO757/zQ+Zcz8dNCyH65gj7iBs5D3QUpVDmBd02w9j9jgUk6Swp4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=thZnMHAA; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="thZnMHAA"
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782156061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yYfFsnpbroLaEhyucoJypWm8v4a6TEOgyaGRt3YJf+M=;
	b=thZnMHAAAap0EUYTJma5A1H88zx1n6ZWFnHEIO6ucWz+W32Io8YxjzXv5OhoGU+fDrMwGG
	XM/MhOxN6hSOjdF6JlG9fidijvXdm9iUcOU7PYH1D7Y6QCFmheNz89K5XVuc7m0en/yhj8
	aCmyBXoHuLhi+qy1wfizMYidMeDdGl8=
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
In-Reply-To: <ajlopihdkRALO-do@kernel.org>
Date: Mon, 22 Jun 2026 12:20:48 -0700
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>,
 KVMARM <kvmarm@lists.linux.dev>
Message-Id: <DC6D08B0-9CB2-48B9-BF1C-4300C095F2B6@linux.dev>
References: <ajlopihdkRALO-do@kernel.org>
To: Oliver Upton <oupton@kernel.org>
X-Migadu-Flow: FLOW_OUT



> On Jun 22, 2026, at 9:54=E2=80=AFAM, Oliver Upton <oupton@kernel.org> wrot=
e:
>=20
> =EF=BB=BFOn Fri, Jun 19, 2026 at 11:05:57AM -0700, Roman Gushchin wrote:
>>=20
>>>> On Jun 19, 2026, at 9:45=E2=80=AFAM, Oliver Upton <oupton@kernel.org> w=
rote:
>>>=20
>>> =EF=BB=BFHey,
>>>=20
>>>> On Fri, Jun 19, 2026 at 03:19:05PM +0100, Fuad Tabba wrote:
>>>> Hi folks,
>>>>=20
>>>> I really like Sashiko and find it very useful. It's flagged real bugs
>>>> in series I and others have posted to the list (e.g. [1][2][3]), and I
>>>> run it locally before sending, which has saved me a few respins.
>>>>=20
>>>> That said, it's been posting a lot lately, so it seemed worth asking
>>>> how the review emails to the list are working out, and whether we
>>>> should change anything.
>>>=20
>>> So this is entirely my fault since I added the email configuration for
>>> the kvmarm list. Sashiko has been finding some truly nasty bugs, posting=

>>> on-list is the easiest way to get attention from the right folks to get
>>> things fixed.
>>>=20
>>> With that being said, the signal to noise ratio hasn't been ideal.
>>>=20
>>>> These fixes will take a while to land, so the question is what to do
>>>> meanwhile. Some options, and surely others:
>>>>=20
>>>> - Leave it as-is while the fixes propagate.
>>>> - Stop the emails but keep the reviews on sashiko.dev, so people can
>>>> look rather than have them pushed.
>>>> - Disable the emails until the noise is down to a reasonable level,
>>>> then re-enable.
>>>=20
>>> This sounds like the right approach. I'd like to re-enable emails once
>>> we're happy with the quality of reviews.
>>=20
>> =46rom my perspective there are 3 main factors affecting the quality of r=
eviews:
>> 1) llm model capabilities. we have little control here, but it=E2=80=99s r=
easonable to expect that things will get better.
>> 2) sashiko=E2=80=99s common code/harness. we=E2=80=99re improving it, but=
 I=E2=80=99m not sure we have a lot of room left here, probably some. also, t=
here are many tradeoffs to make, e.g. if we start verifying each issue separ=
ately, it almost certainly will improve signal/noise, but it will require wa=
y more tokens and will be slower.
>> 3) developing per-subsystem prompts. there is a lot of potential here, bu=
t this is where we mostly rely on maintainers and developers.
>>=20
>> Also not trying to push back on the decision, but I think it=E2=80=99s wo=
rth asking what is a reasonable level?
>> I tried to measure the true positive rate several times based on human fe=
edback and it always was at least ~80% (and usually more for critical/high s=
everity bugs).
>> And I=E2=80=99m afraid that it won=E2=80=99t be ~100% without compromisin=
g on the ability to find bugs. The reality is that there is a significant pe=
rcentage of issues which are not exactly black and white and even people don=
=E2=80=99t necessarily agree if it=E2=80=99s an issue or not. Also there is a=
 non-trivial amount of cases when ai findings are incorrectly dismissed by h=
umans.
>>=20
>> I=E2=80=99m not trying to pretend it=E2=80=99s perfect (it=E2=80=99s not)=
, and I certainly expect it to be better going forward (and I=E2=80=99m work=
ing on it),
>> but the point is that we might not see _dramatic_ improvements going forw=
ard simple because there is no room left for it,
>> it=E2=80=99s more like a long tail of grey zone issues.
>=20
> Marc touched on it as well, but the architecture hallucinations have
> been pretty difficult to unwind since I don't expect most contributors
> to know all the ins and outs of the Arm ARM.
>=20
> I'm not terribly worried about this, especially since Fuad is actively
> working to improve the review prompts / context.

Awesome, thanks!

>=20
>>> On another note: Roman, is it possible to separately report pre-existing=

>>> issues from findings in a patch? Maintainers have a higher likelihood of=

>>> caring about these than individual contributors anyway.
>>=20
>> It=E2=80=99s certainly possible, but how exactly do you see it?
>>=20
>> It=E2=80=99s already somewhat separated (separate counters, separate list=
 on top of each email).
>> I don=E2=80=99t want to stop reporting them completely (but we can discus=
s it), because it produces
>> a constant stream of fixes in the upstream kernel (in hundreds already).
>>=20
>> I plan to improve it to e.g. not report multiple times within the same pa=
tchset.
>=20
> Sorry, I was a bit vague.
>=20
> Including pre-existing issues inline with the reviews is fine by me.
> What I was actually hoping for is a way to view all the existing bugs in
> a single place, either as a summary email on a regular cadence or a view
> on the webpage.
>=20
> We wont have enough cycles to go through every Sashiko review so I'm
> worried that some bugs will be missed otherwise.

I=E2=80=99m working on something like this and it will be available soon-ish=
.

Thanks=
