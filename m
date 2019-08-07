Return-Path: <SRS0=czFP=WD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MIME_HTML_MOSTLY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED8AC433FF
	for <kvmarm@archiver.kernel.org>; Wed,  7 Aug 2019 14:28:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A64D321E70
	for <kvmarm@archiver.kernel.org>; Wed,  7 Aug 2019 14:28:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fXOG6vqS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A64D321E70
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1397E4A541;
	Wed,  7 Aug 2019 10:28:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZPXl7B89MBPs; Wed,  7 Aug 2019 10:28:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B4AE4A561;
	Wed,  7 Aug 2019 10:28:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E71524A53D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Aug 2019 10:28:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XH27HStk9qdu for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Aug 2019 10:28:20 -0400 (EDT)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 151614A521
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Aug 2019 10:28:20 -0400 (EDT)
Received: by mail-wm1-f67.google.com with SMTP id v19so240467wmj.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Aug 2019 07:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
 :references; bh=TGdi/trEU/o10jic/YDvIJXbB9BZdk7Ea9wZcpPfTDg=;
 b=fXOG6vqSgWiSbFsaLg2/O1IPVwFlWdfIkgaTDLIvZpmgYCgDtKMoJ3FSf8b83IJBQk
 5A39S9yPZr7vqFTlmTliGbN+0Gy90QW7uRp1EjcRZAZgzCzjhJQDDEywZFn3XRtKR3Cj
 63b5mvmr7g5JNJjBijdLUCd4mPsPSJSsw9d/HE/IKOM1y/k+TUq0d9dE00pVJ1DHn/pH
 bE5NERgQctwPXMRM0aHziMaKxy6CjXJRdhvWUJw10zHIhpCYCoX+lSvp24to396vVEDR
 IWAUH+0dxfPEY3jyUcDnQ0SSc/WrMfLW4j7QIawmDIgSc6Eax9Xzu4/mJyLhTg4BlZdq
 uVbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:message-id:mime-version:subject:date
 :in-reply-to:cc:to:references;
 bh=TGdi/trEU/o10jic/YDvIJXbB9BZdk7Ea9wZcpPfTDg=;
 b=QAuMqfGBf5CQMLUshCsYa/kPvTCu6EnYU4hOC74G6vvN+IHSx9R5lnzqg8f0lSAwIJ
 1q7au44obniCaSHtsFpYCAwM5sbQR3gtjTfGNpY7MN52vrCYcRatbvy+Crh7pZakVyfQ
 QJuGNbeaO6vxhtFkzqBllnE0K89PFXIA6Q8f1Yh5X+DO+kU0eF5OrlvUg9HiZ9J+t31h
 QqrLJ6pSPdK3wz/WAFbkDZnIeqNdhIfPhJGOFn3lnY+Rzghr/fWlJk7sCZT+sl4uCq2L
 hqE7YIx7y1e4YzZdot7gGrct9qYluKe5/b/q0rsMsSoqC/+XV1b0xdURA9EPaPLI5L5b
 kg6w==
X-Gm-Message-State: APjAAAXxTwStKqMdxjzhpTqfb8FdqOyQBAQEmxPBuQZB4ilh2VzV1pcM
 D3eYAPdi6gbBmDbbw+rMeCQ=
X-Google-Smtp-Source: APXvYqxPn3bhTKOfiDLlfSD40SpCUw8WuRmDDi3VedTgBED6WDhNkfXFMxHxJTxTX3zD6YnFybxx7Q==
X-Received: by 2002:a7b:cb89:: with SMTP id m9mr297593wmi.50.1565188098667;
 Wed, 07 Aug 2019 07:28:18 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b6a:1220:f5f6:baf5:c085:94c5?
 ([2a01:e35:8b6a:1220:f5f6:baf5:c085:94c5])
 by smtp.gmail.com with ESMTPSA id z8sm7898157wru.13.2019.08.07.07.28.12
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Wed, 07 Aug 2019 07:28:17 -0700 (PDT)
From: Christophe de Dinechin <christophe.de.dinechin@gmail.com>
X-Google-Original-From: Christophe de Dinechin <christophe@dinechin.org>
Message-Id: <9F77FA64-C71B-4025-A58D-3AC07E6688DE@dinechin.org>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH 1/9] KVM: arm64: Document PV-time interface
Date: Wed, 7 Aug 2019 16:28:11 +0200
In-Reply-To: <ff2d038d-d866-65fa-655d-b9865bf14016@arm.com>
To: Steven Price <steven.price@arm.com>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-2-steven.price@arm.com> <m1mugnmv0x.fsf@dinechin.org>
 <ff2d038d-d866-65fa-655d-b9865bf14016@arm.com>
X-Mailer: Apple Mail (2.3445.104.11)
Cc: Christophe de Dinechin <christophe.de.dinechin@gmail.com>,
 KVM list <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 open list <linux-kernel@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6304059910904961242=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============6304059910904961242==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_F20250AD-5FB7-44C9-9134-0FC36C4420F6"


--Apple-Mail=_F20250AD-5FB7-44C9-9134-0FC36C4420F6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On 7 Aug 2019, at 15:21, Steven Price <steven.price@arm.com> wrote:
>=20
> On 05/08/2019 17:40, Christophe de Dinechin wrote:
>>=20
>> Steven Price writes:
>>=20
>>> Introduce a paravirtualization interface for KVM/arm64 based on the
>>> "Arm Paravirtualized Time for Arm-Base Systems" specification DEN =
0057A.
>>>=20
>>> This only adds the details about "Stolen Time" as the details of =
"Live
>>> Physical Time" have not been fully agreed.
>>>=20
>> [...]
>>=20
>>> +
>>> +Stolen Time
>>> +-----------
>>> +
>>> +The structure pointed to by the PV_TIME_ST hypercall is as follows:
>>> +
>>> +  Field       | Byte Length | Byte Offset | Description
>>> +  ----------- | ----------- | ----------- | =
--------------------------
>>> +  Revision    |      4      |      0      | Must be 0 for version =
0.1
>>> +  Attributes  |      4      |      4      | Must be 0
>>> +  Stolen time |      8      |      8      | Stolen time in unsigned
>>> +              |             |             | nanoseconds indicating =
how
>>> +              |             |             | much time this VCPU =
thread
>>> +              |             |             | was involuntarily not
>>> +              |             |             | running on a physical =
CPU.
>>=20
>> I know very little about the topic, but I don't understand how the =
spec
>> as proposed allows an accurate reading of the relation between =
physical
>> time and stolen time simultaneously. In other words, could you draw
>> Figure 1 of the spec from within the guest? Or is it a non-objective?
>=20
> Figure 1 is mostly attempting to explain Live Physical Time (LPT), =
which
> is not part of this patch series. But it does touch on stolen time by
> the difference between "live physical time" and "virtual time".
>=20
> I'm not sure what you mean by "from within the guest". =46rom the
> perspective of the guest the parts of the diagram where the guest =
isn't
> running don't exist (therefore there are discontinuities in the
> "physical time" and "live physical time" lines).

I meant: If I run code within the guest that attempts to draw Figure 1,
race conditions may cause the diagram actually drawn by your guest
program to look completely wrong on occasions.

> This patch series doesn't attempt to provide the guest with a view of
> "physical time" (or LPT) - but it might be able to observe that by
> consulting something external (e.g. an NTP server, or an emulated RTC
> which reports wall-clock time).

=E2=80=A6 with what appear to be like a built-in race condition, as you =
correctly
identified. I was wondering if the built-in race condition was =
deliberate
and/or necessary, or if it was irrelevant for the planned uses of the =
value.

> What it does provide is a mechanism for obtaining the difference (as
> reported by the host) between "live physical time" and "virtual time" =
-
> this is reported in nanoseconds in the above structure.
>=20
>> For example, if you read the stolen time before you read CNTVCT_EL0,
>> isn't it possible for a lengthy event like a migration to occur =
between
>> the two reads, causing the stolen time to be obsolete and off by =
seconds?
>=20
> "Lengthy events" like migration are represented by the "paused" state =
in
> the diagram - i.e. it's the difference between "physical time" and =
"live
> physical time". So stolen time doesn't attempt to represent that.
>=20
> And yes, there is a race between reading CNTVCT_EL0 and reading stolen
> time - but in practice this doesn't really matter. The usual =
pseudo-code
> way of using stolen time is:

I=E2=80=99m assuming this is the guest scheduler you are talking about,
and I=E2=80=99m assuming virtualization can preempt that code anywhere.
Maybe that=E2=80=99s where I=E2=80=99m wrong?

For the sake of the argument, assume there is a 1s pause.
Not completely unreasonable in a migration scenario.

>  * scheduler captures stolen time from structure and CNTVCT_EL0:
>      before_timer =3D CNTVCT_EL0

[insert optional 1s pause here, case A]

>      before_stolen =3D stolen
>  * schedule in process
>  * process is pre-empted (or blocked in some way)
>  * scheduler captures stolen time from structure and CNTVCT_EL0:
>      after_timer =3D CNTVCT_EL0

[insert optional 1s pause here, case B]

>      after_stolen =3D stolen
>      time =3D to_nsecs(after_timer - before_timer) -
>             (after_stolen - before_stolen)

In case A, time is too big by one second. In case B, it is too small,
to the point where your code might need to be ready for
=E2=80=9Ctime=E2=80=9D unexpectedly showing up as negative.

>=20
> The scheduler can then charge the process for "time" nanoseconds of
> time. This ensures that a process isn't unfairly penalised if the host
> doesn't schedule the VCPU while it is supposed to be running.
>=20
> The race is very small in comparison to the time the process is =
running,
> and in the worst case just means the process is charged slightly more
> (or less) than it should be.

At this point, what I don=E2=80=99t understand is why the race would be
=E2=80=9Cvery small=E2=80=9D or why you would only be charged =
=E2=80=9Cslightly=E2=80=9D more or less?

> I guess if you're really worried about it, you could do a dance like:
>=20
> 	do {
> 		before =3D stolen
> 		timer =3D CNTVCT_EL0
> 		after =3D stolen
> 	} while (before !=3D after);

That will work as long as nothing in that loop requires something
that would cause `stolen` to jump. If there is such a guarantee,
then that=E2=80=99s even efficient, because in most cases the loop
would only run once, at the cost of one extra read and one test.

> But I don't see the need to have such an accurate view of elapsed time
> that the VCPU was scheduled. And of course at the moment (without this
> series) the guest has no idea about time stolen by the host.

I=E2=80=99m certainly not arguing that exposing stolen time is a bad =
idea,
I=E2=80=99m only wondering if the proposed solution is racy, and if so, =
if
it is intentional.

If it=E2=80=99s indeed racy, the problem could be mitigated in a number =
of
ways

a) document your loop or something similar as being the recommended
way to avoid the race, and then ensure that the loop actually
will always work as intended. The upside is that it=E2=80=99s just a =
change in
some comments or documentation.

b) having a single interface that exposes multiple times. For example,
you could have a copy of CNTVCT_EL0 written alongside stolen time,
and then the scheduler could use that copy for its decision.


Thanks
Christophe=

--Apple-Mail=_F20250AD-5FB7-44C9-9134-0FC36C4420F6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; =
charset=3Dutf-8"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; line-break: after-white-space;" class=3D""><br =
class=3D""><div><br class=3D""><blockquote type=3D"cite" class=3D""><div =
class=3D"">On 7 Aug 2019, at 15:21, Steven Price &lt;<a =
href=3D"mailto:steven.price@arm.com" =
class=3D"">steven.price@arm.com</a>&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">On 05/08/2019 17:40, Christophe =
de Dinechin wrote:</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><blockquote type=3D"cite" =
style=3D"font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><br class=3D"">Steven Price =
writes:<br class=3D""><br class=3D""><blockquote type=3D"cite" =
class=3D"">Introduce a paravirtualization interface for KVM/arm64 based =
on the<br class=3D"">"Arm Paravirtualized Time for Arm-Base Systems" =
specification DEN 0057A.<br class=3D""><br class=3D"">This only adds the =
details about "Stolen Time" as the details of "Live<br class=3D"">Physical=
 Time" have not been fully agreed.<br class=3D""><br =
class=3D""></blockquote>[...]<br class=3D""><br class=3D""><blockquote =
type=3D"cite" class=3D"">+<br class=3D"">+Stolen Time<br =
class=3D"">+-----------<br class=3D"">+<br class=3D"">+The structure =
pointed to by the PV_TIME_ST hypercall is as follows:<br class=3D"">+<br =
class=3D"">+ &nbsp;Field &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| Byte =
Length | Byte Offset | Description<br class=3D"">+ &nbsp;----------- | =
----------- | ----------- | --------------------------<br class=3D"">+ =
&nbsp;Revision &nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4 =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0 =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| Must be 0 for version 0.1<br class=3D"">+ =
&nbsp;Attributes &nbsp;| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4 =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4 =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| Must be 0<br class=3D"">+ &nbsp;Stolen =
time | &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;8 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;8 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| Stolen =
time in unsigned<br class=3D"">+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;| =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| =
nanoseconds indicating how<br class=3D"">+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;| =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| =
much time this VCPU thread<br class=3D"">+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;| =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| =
was involuntarily not<br class=3D"">+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;| =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| =
running on a physical CPU.<br class=3D""></blockquote><br class=3D"">I =
know very little about the topic, but I don't understand how the spec<br =
class=3D"">as proposed allows an accurate reading of the relation =
between physical<br class=3D"">time and stolen time simultaneously. In =
other words, could you draw<br class=3D"">Figure 1 of the spec from =
within the guest? Or is it a non-objective?<br class=3D""></blockquote><br=
 style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">Figure 1 is mostly attempting to =
explain Live Physical Time (LPT), which</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">is not part of this patch series. But it does touch on stolen =
time by</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">the =
difference between "live physical time" and "virtual time".</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">I'm not sure what you mean by =
"from within the guest". =46rom the</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">perspective of the guest the parts of the diagram where the =
guest isn't</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">running don't =
exist (therefore there are discontinuities in the</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">"physical time" and "live =
physical time" lines).</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""></div></blockquote><div><br =
class=3D""></div><div>I meant: If I run code within the guest that =
attempts to draw Figure 1,</div><div>race conditions may cause the =
diagram actually drawn by your guest</div><div>program to look =
completely wrong on occasions.</div><br class=3D""><blockquote =
type=3D"cite" class=3D""><div class=3D""><span style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">This patch series doesn't attempt to provide the guest with a =
view of</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">"physical =
time" (or LPT) - but it might be able to observe that by</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">consulting something external =
(e.g. an NTP server, or an emulated RTC</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">which reports wall-clock time).</span><br style=3D"caret-color:=
 rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""></div></blockquote><div><br =
class=3D""></div><div>=E2=80=A6 with what appear to be like a built-in =
race condition, as you correctly</div><div>identified. I was wondering =
if the built-in race condition was deliberate</div><div>and/or =
necessary, or if it was irrelevant for the planned uses of the =
value.</div><br class=3D""><blockquote type=3D"cite" class=3D""><div =
class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">What it does =
provide is a mechanism for obtaining the difference (as</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">reported by the host) between =
"live physical time" and "virtual time" -</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">this is reported in nanoseconds in the above =
structure.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><blockquote type=3D"cite" style=3D"font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-size-adjust: auto; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D"">For =
example, if you read the stolen time before you read CNTVCT_EL0,<br =
class=3D"">isn't it possible for a lengthy event like a migration to =
occur between<br class=3D"">the two reads, causing the stolen time to be =
obsolete and off by seconds?<br class=3D""></blockquote><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">"Lengthy events" like migration =
are represented by the "paused" state in</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">the diagram - i.e. it's the difference between "physical =
time" and "live</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">physical time". So stolen time doesn't attempt to represent =
that.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">And yes, =
there is a race between reading CNTVCT_EL0 and reading stolen</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">time - but in practice this =
doesn't really matter. The usual pseudo-code</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">way of using stolen time =
is:</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""></div></blockquote><div><br class=3D""></div>I=E2=80=99m=
 assuming this is the guest scheduler you are talking =
about,</div><div>and I=E2=80=99m assuming virtualization can preempt =
that code anywhere.</div><div>Maybe that=E2=80=99s where I=E2=80=99m =
wrong?</div><div><br class=3D""></div><div>For the sake of the argument, =
assume there is a 1s pause.</div><div>Not completely unreasonable in a =
migration scenario.</div><div><br class=3D""></div><div><blockquote =
type=3D"cite" class=3D""><div class=3D""><span style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">&nbsp;* scheduler captures stolen time from structure and =
CNTVCT_EL0:</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" =
class=3D"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;before_timer =3D =
CNTVCT_EL0</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""></div></blockquote><div><br =
class=3D""></div><div>[insert optional 1s pause here, case =
A]</div><div><br class=3D""></div><blockquote type=3D"cite" =
class=3D""><div class=3D""><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;before_stolen =3D =
stolen</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">&nbsp;* =
schedule in process</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">&nbsp;* process is pre-empted (or blocked in some =
way)</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">&nbsp;* =
scheduler captures stolen time from structure and CNTVCT_EL0:</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" =
class=3D"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;after_timer =3D =
CNTVCT_EL0</span></div></blockquote><div><br class=3D""></div><div>[insert=
 optional 1s pause here, case B]</div><br class=3D""><blockquote =
type=3D"cite" class=3D""><div class=3D""><span style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;after_stolen =3D =
stolen</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" =
class=3D"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;time =3D to_nsecs(after_timer - =
before_timer) -</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;(after_stolen - before_stolen)</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""></div></blockquote><div><br =
class=3D""></div><div>In case A, time is too big by one second. In case =
B, it is too small,</div><div>to the point where your code might need to =
be ready for</div><div>=E2=80=9Ctime=E2=80=9D unexpectedly showing up as =
negative.</div><br class=3D""><blockquote type=3D"cite" class=3D""><div =
class=3D""><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">The scheduler =
can then charge the process for "time" nanoseconds of</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">time. This ensures that a =
process isn't unfairly penalised if the host</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">doesn't schedule the VCPU while =
it is supposed to be running.</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">The race is very small in comparison to the time the process =
is running,</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">and in the =
worst case just means the process is charged slightly more</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">(or less) than it should =
be.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""></div></blockquote><div><br class=3D""></div><div>At =
this point, what I don=E2=80=99t understand is why the race would =
be</div><div>=E2=80=9Cvery small=E2=80=9D or why you would only be =
charged =E2=80=9Cslightly=E2=80=9D more or less?</div><br =
class=3D""><blockquote type=3D"cite" class=3D""><div class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">I guess if you're really worried =
about it, you could do a dance like:</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 19px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">do =
{</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 19px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span class=3D"Apple-tab-span" style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">	</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 19px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">before =3D =
stolen</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span class=3D"Apple-tab-span" style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">	</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 19px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">timer =3D =
CNTVCT_EL0</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span class=3D"Apple-tab-span" style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">	</span><span class=3D"Apple-tab-span" =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: pre; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 19px; font-style: normal; font-variant-caps: normal; =
font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">after =3D =
stolen</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span class=3D"Apple-tab-span" style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: pre; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">	</span><span style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">} while (before !=3D after);</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""></div></blockquote><div><br =
class=3D""></div><div>That will work as long as nothing in that loop =
requires something</div><div>that would cause `stolen` to jump. If there =
is such a guarantee,</div><div>then that=E2=80=99s even efficient, =
because in most cases the loop</div><div>would only run once, at the =
cost of one extra read and one test.</div><br class=3D""><blockquote =
type=3D"cite" class=3D""><div class=3D""><span style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 19px; font-style: =
normal; font-variant-caps: normal; font-weight: normal; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;" =
class=3D"">But I don't see the need to have such an accurate view of =
elapsed time</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;" class=3D""><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 19px; font-style: normal; font-variant-caps: =
normal; font-weight: normal; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;" class=3D"">that the VCPU =
was scheduled. And of course at the moment (without this</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;" class=3D""><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
19px; font-style: normal; font-variant-caps: normal; font-weight: =
normal; letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;" class=3D"">series) the guest has no idea =
about time stolen by the host.</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 19px; font-style: normal; =
font-variant-caps: normal; font-weight: normal; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;" class=3D""></div></blockquote><div><br =
class=3D""></div><div>I=E2=80=99m certainly not arguing that exposing =
stolen time is a bad idea,</div><div>I=E2=80=99m only wondering if the =
proposed solution is racy, and if so, if</div><div>it is =
intentional.</div><div><br class=3D""></div><div>If it=E2=80=99s indeed =
racy, the problem could be mitigated in a number =
of</div><div>ways</div><div><br class=3D""></div><div><div>a) document =
your loop or something similar as being the recommended</div><div>way to =
avoid the race, and then ensure that the loop actually</div><div>will =
always work as intended. The upside is that it=E2=80=99s just a change =
in</div><div>some comments or documentation.</div><div><br =
class=3D""></div></div><div>b) having a single interface that exposes =
multiple times. For example,</div><div>you could have a copy of =
CNTVCT_EL0 written alongside stolen time,</div><div>and then the =
scheduler could use that copy for its decision.</div><div><br =
class=3D""></div><div><br =
class=3D""></div><div>Thanks</div><div>Christophe</div></div></body></html=
>=

--Apple-Mail=_F20250AD-5FB7-44C9-9134-0FC36C4420F6--

--===============6304059910904961242==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============6304059910904961242==--
