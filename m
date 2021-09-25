Return-Path: <SRS0=Rd7Q=OP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77993C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 06:46:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D4A3361260
	for <kvmarm@archiver.kernel.org>; Sat, 25 Sep 2021 06:46:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D4A3361260
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 467784B086;
	Sat, 25 Sep 2021 02:46:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l0S6c7Wkie8O; Sat, 25 Sep 2021 02:46:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 392AB4B0C0;
	Sat, 25 Sep 2021 02:46:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A12B4B086
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Sep 2021 02:45:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id krviAzY020UI for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Sep 2021 02:45:56 -0400 (EDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com
 [209.85.167.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 63BF44031F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Sep 2021 02:45:56 -0400 (EDT)
Received: by mail-lf1-f45.google.com with SMTP id y28so49577684lfb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 23:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:from:date:message-id:subject:to;
 bh=vpAqGeF5KwkRU7JzE5gc6oNJiu5n0YK8Gc3qiLExMmw=;
 b=ce/Ine+l4S6DEP+NFcW0iMNLFlgoBmkfNBBTRRaeDlZFB2mCbwMmM4beFA03i1OAm8
 gPkrC+tGUniL7diNAmuaSzejcn9z5wPgljU83ZGqEKCpOiAzhmc/tJPiYA31lTp2V7cc
 NKb0iTVJwW75AdoPXEB/ZNFlmq5PJF9tpvbnY9uYBH5JGi4wcFaylNZcAaIBCYw0Z8nw
 lP111bfEw1taDkpkNt9cSLgxNBlExG5RB1YOJO448knJRsx7O3bhKYzul2aLbAS3jr4o
 FMf9OcphJ7bedo1VlojIG/qrNcu2j0X2Oab/G4NE06b1nRubzNUlpVahzNSJyFK/TnD7
 4TJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
 bh=vpAqGeF5KwkRU7JzE5gc6oNJiu5n0YK8Gc3qiLExMmw=;
 b=uurVzsY0FJgUJ0lNpc1VVkbk8uipo195o8ic0+9pUFTFOVXdXbCxS3TuXOdLm3wrDb
 FXYfxlmpJmWO10FLsgkBjWvRzbdIzhnsAVZm6Vro29ufJ+Uawz8qsWowytQUgpGh8jwU
 W36kCKrDhJnEp0hwOg0R8TbQ+AN5mlufc8bGuWFFBLUtyeAXtQoParAJVtsj0gDRfvmW
 If//DU+wTLoz4zO7btmVThkBFpaRiIb1ok/TOqwITZidjCJIKm8RDvw4z8uzjfjiFddf
 Ae80xxeqZ4Hh7NzClDUTXrjOWh8j43X1C8aAZLdq9EQT+J2MtOHUKhojBVukLgKDVkBJ
 NuPA==
X-Gm-Message-State: AOAM533TuMqscExE3A875mRjdKxjD9tOhhvC1AsTMHNMn/ABhby7btMt
 HUUog5RlJeSqkT0Z8zysxM8s6uyNMBPmbzASDbb/VCegB0F3TQ==
X-Google-Smtp-Source: ABdhPJzsQ3ae+IC4iH1Y/6V/rzRH2Jn0SoBLSiwhNOck0Y+Zzm3ynbxKkQjK3iXKOkX/rh94qQAgiec518zpUjTjD4Y=
X-Received: by 2002:a05:6512:a92:: with SMTP id
 m18mr13195740lfu.608.1632552355030; 
 Fri, 24 Sep 2021 23:45:55 -0700 (PDT)
MIME-Version: 1.0
From: Chenxu Wang <irakatz51@gmail.com>
Date: Sat, 25 Sep 2021 14:45:44 +0800
Message-ID: <CAFLP=uCvQ=xLaMmaSReWWYHC_EBf_k5tf1akp4GLOym9RVRCkw@mail.gmail.com>
Subject: Execute "SMC" instruction in Guest OS
To: kvmarm@lists.cs.columbia.edu
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
Content-Type: multipart/mixed; boundary="===============8244416286989577084=="
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

--===============8244416286989577084==
Content-Type: multipart/alternative; boundary="00000000000032eb5805cccc375c"

--00000000000032eb5805cccc375c
Content-Type: text/plain; charset="UTF-8"

Hi all,

I want the Guest OS to use the Arm-TF service in Host OS (It is the same as
using Trusted Application in OP-TEE). So I should provide some parameters
and call SMC instruction.

But it returns an "Undefined Instruction" in my Linux v4.9.51.
I find that KVM calls a " kvm_inject_undefined(vcpu);" when handling the
SMC instruction.

So, if I want the Guest OS to use the "Arm-TF service" or "TA", should I
simply change the kvm_inject_undefined() as "SMC #0", and carefully handle
the input parameters? What else should I do?

Sincerely,
Wang Chenxu

--00000000000032eb5805cccc375c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi all,<div><br></div><div>I want the Guest OS to use the =
Arm-TF service in Host OS (It is the same as using Trusted Application in O=
P-TEE). So I should provide some parameters and call SMC instruction.</div>=
<div><br></div><div>But it returns an &quot;Undefined Instruction&quot; in =
my Linux v4.9.51.</div><div>I find that KVM calls a &quot;	kvm_inject_undef=
ined(vcpu);&quot; when handling the SMC instruction.=C2=A0</div><div><br></=
div><div>So, if I want the Guest OS to use the &quot;Arm-TF service&quot; o=
r &quot;TA&quot;, should I simply change the kvm_inject_undefined() as &quo=
t;SMC #0&quot;, and carefully handle the input parameters? What else should=
 I do?<br></div><div><br></div><div>Sincerely,</div><div>Wang Chenxu</div><=
/div>

--00000000000032eb5805cccc375c--

--===============8244416286989577084==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============8244416286989577084==--
