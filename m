From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 5/6] docs: mention modifying env vars in
 README
Date: Thu, 12 Jan 2017 18:14:29 +0100
Message-ID: <20170112171429.ldiwl7eduxwstgkq@hawk.localdomain>
References: <20170111162841.15569-1-alex.bennee@linaro.org>
 <20170111162841.15569-6-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF1D84019A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 12:12:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b9YwJNiyt910 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 12:12:50 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EAC7340194
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 12:12:49 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170111162841.15569-6-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 11, 2017 at 04:28:40PM +0000, Alex Benn=E9e wrote:
> I had started adding a series of flags to control the run-time
> behaviour of the tests but it was pointed out env vars can already do
> that. Mention them in the README so others can find out to.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> ---
>  README.md | 8 ++++++++
>  1 file changed, 8 insertions(+)
> =

> diff --git a/README.md b/README.md
> index 9462824..fa3a445 100644
> --- a/README.md
> +++ b/README.md
> @@ -47,6 +47,14 @@ environment variable:
>  =

>      QEMU=3D/tmp/qemu/x86_64-softmmu/qemu-system-x86_64 ./x86-run ./x86/m=
sr.flat
>  =

> +To force the acceleration mode:
> +
> +    ACCEL=3Dtcg ./run_tests.sh
> +
> +To extend or disable the timeouts:
> +
> +    TIMEOUT=3D0 ./run_tests.sh
> +

This is a nice addition to the README, but please add more detail.

To force the use of TCG:
 ACCEL=3Dtcg ./run_tests.sh

To force failure when KVM is not present:
 ACCEL=3Dkvm ./run_tests.sh

To modify the timeout:
 TIMEOUT=3D$DURATION ./run_tests.sh # man timeout(1) for duration format
 TIMEOUT=3D0 ./run_tests.sh # disable the timeout

or something like that...

thanks,
drew


>  # Contributing
>  =

>  ## Directory structure
> -- =

> 2.11.0
> =

> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
