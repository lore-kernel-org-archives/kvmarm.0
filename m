From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 3/6] docs: move README to README.md and
 symlink
Date: Thu, 12 Jan 2017 18:04:21 +0100
Message-ID: <20170112170421.kr4jlyjzavifu2f6@hawk.localdomain>
References: <20170111162841.15569-1-alex.bennee@linaro.org>
 <20170111162841.15569-4-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1841401A1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 12:02:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vuz2oZIN1+Ml for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 12:02:39 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E10184019A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 12:02:39 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170111162841.15569-4-alex.bennee@linaro.org>
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

On Wed, Jan 11, 2017 at 04:28:38PM +0000, Alex Benn=E9e wrote:
> This allows a slightly nicer formatting of the text when displayed on
> some repository hosts. We keep a symlink from README for the
> old-school purists.
> =

> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> ---
>  README    | 69 +----------------------------------------------------
>  README.md | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  2 files changed, 82 insertions(+), 68 deletions(-)
>  mode change 100644 =3D> 120000 README
>  create mode 100644 README.md

Please use 'format-patch -M' to create patches when renaming files.
I'm not sure I care about having a .md version or not, but only
one README* file in the root dir would be my preference, i.e. if we
want a .md version, then let's just have that, i.e no symlink.

Thanks,
drew
