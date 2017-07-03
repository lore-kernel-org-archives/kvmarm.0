From: Raz <raziebe@gmail.com>
Subject: How to trap a real interrupt to EL2 ?
Date: Mon, 3 Jul 2017 21:56:06 +0000
Message-ID: <CAPB=Z-o0-fGEvaxmwUVnSUTUAVWa0GgWupaaFcjJNecpeX3mrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3069263808638318271=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1390C40D38
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 17:56:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DFNxGgCqAALt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Jul 2017 17:56:09 -0400 (EDT)
Received: from mail-lf0-f53.google.com (mail-lf0-f53.google.com
 [209.85.215.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2A6DD40D25
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Jul 2017 17:56:08 -0400 (EDT)
Received: by mail-lf0-f53.google.com with SMTP id b207so109088003lfg.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Jul 2017 14:56:28 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

--===============3069263808638318271==
Content-Type: multipart/alternative; boundary="001a11c108ecb20f5d055370d648"

--001a11c108ecb20f5d055370d648
Content-Type: text/plain; charset="UTF-8"

Hey

I am trying to trap any real IRQ  into EL2.
I created a thin hypervisor with mmu enabled and set hcr_el2 as follows:
hcr_el2= HCR_IMO  | HCR_VM | HCR_RW.


Now it seems that once I set hcr_el2 to the above value and then exit from
EL2 I immediately jump back to EL2.

Any idea why ?

--001a11c108ecb20f5d055370d648
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>Hey<br><br></div>I am trying to trap a=
ny real IRQ=C2=A0 into EL2. <br>I created a thin hypervisor with mmu enable=
d and set hcr_el2 as follows: <br>hcr_el2=3D HCR_IMO=C2=A0 | HCR_VM | HCR_R=
W.<br><br><br></div>Now it seems that once I set hcr_el2 to the above value=
 and then exit from EL2 I immediately jump back to EL2.<br></div><br></div>=
Any idea why ?<br><br><br></div>

--001a11c108ecb20f5d055370d648--

--===============3069263808638318271==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3069263808638318271==--
