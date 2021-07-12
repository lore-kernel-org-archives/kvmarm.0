Return-Path: <SRS0=bTo6=ME=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248A2C07E99
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 20:03:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 92AAD61279
	for <kvmarm@archiver.kernel.org>; Mon, 12 Jul 2021 20:03:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92AAD61279
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0997549F6C;
	Mon, 12 Jul 2021 16:03:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yvPkss7fbZ7u; Mon, 12 Jul 2021 16:03:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6101406E0;
	Mon, 12 Jul 2021 16:03:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CAE740287
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 13:12:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id InJgQk7JA-aY for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Jul 2021 13:12:34 -0400 (EDT)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E68DA4020A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 13:12:33 -0400 (EDT)
Received: by mail-pf1-f169.google.com with SMTP id q10so16973661pfj.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Jul 2021 10:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
 :references; bh=d/B8JhWrn+P+yWZ6A7daQWqsVya17WmZTHfEtvqYBfI=;
 b=hjTL7bTAdN4wcNkHBK9e23RjGwMSI3zDECVWUCkJjSvAfRPg27gXedUHbesheDmWbh
 Cz951EsDV6FeAp8J3fWXAskm+sH81BpBYFGgUZQ1RBRZRI1zh3Vw0R6jHsMBvZ5l0hhz
 zKazvU+1fvn+1OWHy4UanPXk9vz/2+LhUOR5KnwuAh5kfgZdhLISDqEXs67iB8s69Ywp
 zrFiOz78XMjFd8BP5N1GjxX1ITPzIL1fG09Jy2JMPos6B2w3NJKT8soFJ24B2UORGJhF
 EP7YJgCennpf5s5uP+uYm7y5BItu0jPfxW7CZZHWW/fOZsgZRIVvctzGsEtDdY7PKugY
 S9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:message-id:mime-version:subject:date
 :in-reply-to:cc:to:references;
 bh=d/B8JhWrn+P+yWZ6A7daQWqsVya17WmZTHfEtvqYBfI=;
 b=ncHSYst1/1kvvRW9kTUxv8voSSMEa5bwQJS8MseoYZPTEmulVfBcLxd2KhFgALYzHY
 kG5spila5erb4uT/Y1ue9O+C29tRUOKX44w+JRbdS+zaDR7XXLoYJ5OcE0MfFjRmpUJn
 Rv59Be/BGlncZzFzaRU84p18WP46K5WmQUfgV7muLEKTX81EGwQYnZbBVlL2E6VckYQV
 E649sHxvVpKw6dyulKL6dGx+IanLBO90C7QfCPGTr6ztRevvyugEEBBqjVN9Ug2SpnEI
 FzKZyK2lIIsex6afCD5X7ApauuSO0G3OJvwo/e4PMQT8f+zAsVbRbDmBRIatPEt9FL4q
 MnUg==
X-Gm-Message-State: AOAM532qCanuT7RDh6V5fVrDfGNQVTbNrt+vi5qesVPRFnN8ArthpuW7
 xtwEmQpMoxhjZ7WdZks25ug=
X-Google-Smtp-Source: ABdhPJw8dktYBLoO8NebmN3gh5UlbpP9aIxWwZiONjNtgpy7m0NOs/lG3v6o29Rd6bkdRGQNPmk+UA==
X-Received: by 2002:a63:67c5:: with SMTP id b188mr122427pgc.333.1626109952779; 
 Mon, 12 Jul 2021 10:12:32 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net.
 [24.6.216.183])
 by smtp.gmail.com with ESMTPSA id t2sm16281610pfg.73.2021.07.12.10.12.30
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 12 Jul 2021 10:12:31 -0700 (PDT)
From: Nadav Amit <nadav.amit@gmail.com>
Message-Id: <442EEB37-C289-4CB5-8161-71A54A350FEE@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [kvm-unit-tests RFC PATCH 1/5] lib: arm: Print test exit status
 on exit if chr-testdev is not available
Date: Mon, 12 Jul 2021 10:12:29 -0700
In-Reply-To: <20210712170745.wz2jewomlqchmhhb@gator>
To: Andrew Jones <drjones@redhat.com>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-2-alexandru.elisei@arm.com>
 <20210712175155.7c6f8dc3@slackpad.fritz.box>
 <20210712170745.wz2jewomlqchmhhb@gator>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
X-Mailman-Approved-At: Mon, 12 Jul 2021 16:03:51 -0400
Cc: Laurent Vivier <lvivier@redhat.com>,
 linux-s390 <linux-s390@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
 Janosch Frank <frankja@linux.ibm.com>, KVM <kvm@vger.kernel.org>,
 David Hildenbrand <david@redhat.com>, Andre Przywara <andre.przywara@arm.com>,
 cohuck@redhat.com, kvm-ppc@vger.kernel.org, vivek.gautam@arm.com,
 maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu
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
Content-Type: multipart/mixed; boundary="===============5899902070345559318=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu


--===============5899902070345559318==
Content-Type: multipart/signed;
	boundary="Apple-Mail=_DFB43D18-AF75-4226-A207-864049DAB84E";
	protocol="application/pgp-signature";
	micalg=pgp-sha256


--Apple-Mail=_DFB43D18-AF75-4226-A207-864049DAB84E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Jul 12, 2021, at 10:07 AM, Andrew Jones <drjones@redhat.com> wrote:
>=20
> On Mon, Jul 12, 2021 at 05:51:55PM +0100, Andre Przywara wrote:
>> On Fri,  2 Jul 2021 17:31:18 +0100
>> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>=20
>> Hi,
>>=20
>>> The arm64 tests can be run under kvmtool, which doesn't emulate a
>>> chr-testdev device. In preparation for adding run script support for
>>> kvmtool, print the test exit status so the scripts can pick it up =
and
>>> correctly mark the test as pass or fail.
>>>=20
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>> lib/chr-testdev.h |  1 +
>>> lib/arm/io.c      | 10 +++++++++-
>>> lib/chr-testdev.c |  5 +++++
>>> 3 files changed, 15 insertions(+), 1 deletion(-)
>>>=20
>>> diff --git a/lib/chr-testdev.h b/lib/chr-testdev.h
>>> index ffd9a851aa9b..09b4b424670e 100644
>>> --- a/lib/chr-testdev.h
>>> +++ b/lib/chr-testdev.h
>>> @@ -11,4 +11,5 @@
>>>  */
>>> extern void chr_testdev_init(void);
>>> extern void chr_testdev_exit(int code);
>>> +extern bool chr_testdev_available(void);
>>> #endif
>>> diff --git a/lib/arm/io.c b/lib/arm/io.c
>>> index 343e10822263..9e62b571a91b 100644
>>> --- a/lib/arm/io.c
>>> +++ b/lib/arm/io.c
>>> @@ -125,7 +125,15 @@ extern void halt(int code);
>>>=20
>>> void exit(int code)
>>> {
>>> -	chr_testdev_exit(code);
>>> +	if (chr_testdev_available()) {
>>> +		chr_testdev_exit(code);
>>> +	} else {
>>> +		/*
>>> +		 * Print the test return code in the format used by =
chr-testdev
>>> +		 * so the runner script can parse it.
>>> +		 */
>>> +		printf("\nEXIT: STATUS=3D%d\n", ((code) << 1) | 1);
>>=20
>> It's more me being clueless here rather than a problem, but where =
does
>> this "EXIT: STATUS" line come from? In lib/chr-testdev.c I see "%dq",
>> so it this coming from QEMU (but I couldn't find it in there)?
>>=20
>> But anyways the patch looks good and matches what PPC and s390 do.
>=20
> I invented the 'EXIT: STATUS' format for PPC, which didn't/doesn't =
have an
> exit code testdev. Now that it has also been adopted by s390 I guess =
we've
> got a kvm-unit-tests standard to follow for arm :-)

I was unaware of this =E2=80=9Cstandard=E2=80=9D and I mistakenly used a =
different format
for x86, in case someone wants to fix it. [1]

[1] =
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/commit/5747945371b47c51=
cb16187a26111d06f58f06b2

--Apple-Mail=_DFB43D18-AF75-4226-A207-864049DAB84E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEESJL3osl5Ymx/w9I1HaAqSabaD1oFAmDsd/0ACgkQHaAqSaba
D1qcGg//YR7HD5To5tLeXN8Sr9qEqR48YInrt1N2wDkBtgLyixAUA6PPVBfKGPA+
pbV06doi6bj9rF1eHSF/hz2XX3KFp2Z7pmn072Rg3uNMoX857kVJtv+mcPePLsEE
eQ7AZ2ofYf/Oo/xeQI14uoeHOLz276s962h6Vz5+dwfodFSOZ5Q4S2n3BZIkdSVJ
Y1ieWWIlMrerYnIUYJ5yF4yG+PtUFhE7KHoXOhoDFKXlZJ/c/fHZiuA43DlrrSEl
0ycMcKRzdgqyLE3Kd4mvi6A8kKr0piZCABGlrgGib4duoFGyUxkjgDWUqRrnebRr
f6OR57XzMAdnic8MbqdKIvC+Z8LYbE/vOBSrKj3yvjQvXvwbIgZr5tejIutIT7jD
EIVBbqemZ5eKPN3bqIHArNB4t+eO6kroSCgeQVQ0fcg06r/5mxow2qTSt9BQ+DdG
gnSbSugOfdBCnVw6ZC16oR8uxRUcF3UTAfG1SyDAMC9IX9ZbMPpOo9vNhizdUrrV
EU4sc2WVDH5qgr5LYTEm3G+iaBJd8P6JF/qa+2V6dq0UsZTB1OPTUA95zPLRubZ2
PjfZuoxVwx9g9yPDVQaCIicO461N0o92gxfU4pYAST3tNhO1/AcELzUsphDi8eQ8
nAOl4nmKoOVkWpEsy4YQ89o5C7R4zF1lhyfIAAcEM40rZjw8AKw=
=tyb3
-----END PGP SIGNATURE-----

--Apple-Mail=_DFB43D18-AF75-4226-A207-864049DAB84E--

--===============5899902070345559318==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============5899902070345559318==--
