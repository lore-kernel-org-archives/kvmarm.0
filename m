From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC] minimum gcc version for kernel: raise to gcc-4.3 or 4.6?
Date: Sun, 23 Apr 2017 22:13:20 +0200
Message-ID: <CAMuHMdWTiurUSacddYXgW69=QwOrZDV3Zt2DezJauPy8j-GMHw@mail.gmail.com>
References: <20161216105634.235457-1-arnd@arndb.de>
 <3302470.IDcDrWa0u6@wuerfel>
 <CAGXu5jLPRYi+HK=07Zndc8szEKD4mZCqaHJFnHmmoYr7tA1xPw@mail.gmail.com>
 <CAK8P3a2C2WhWjzF=HrzU15Ncg0juR+nstZukBEpqCrVNW5pnDA@mail.gmail.com>
 <CAGXu5jLTR+dY_Ayyix5Tg0Yn9LBFAt=j56MQVdJVGue-R-CizA@mail.gmail.com>
 <CAK8P3a114EVbnhbObfq-4pZp8XCT4fWzMXD+WkRi7iPXs1vFMA@mail.gmail.com>
 <CAGXu5jJpofLF0qAf0-2iNTesZt-X704Q7L=DpQYdtHY5n2HD0w@mail.gmail.com>
 <alpine.LFD.2.20.1704220400380.32200@eddie.linux-mips.org>
 <CAK8P3a28fi0GRcz1yLq+wRkaBBO_w74NnBCY7f3myg78JpaCCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE3A849C29
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 16:10:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id duHHbnUaxC29 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 16:10:35 -0400 (EDT)
Received: from mail-it0-f67.google.com (mail-it0-f67.google.com
 [209.85.214.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8502349C25
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 16:10:35 -0400 (EDT)
Received: by mail-it0-f67.google.com with SMTP id z67so11389793itb.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:13:22 -0700 (PDT)
In-Reply-To: <CAK8P3a28fi0GRcz1yLq+wRkaBBO_w74NnBCY7f3myg78JpaCCQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch <linux-arch@vger.kernel.org>, Kees Cook <keescook@chromium.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, kernel-build-reports@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@armlinux.org.uk>, "Maciej W. Rozycki" <macro@linux-mips.org>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Arnd,

On Sat, Apr 22, 2017 at 5:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Based on what I found so far, gcc-4 can be pretty much ruled out from
> being the minimum version based on the number of failures I got.
> It's much better than 3.4 but much worse than 4.1 or 4.2 which seem
> fixable on MIPS and x86 at least, and may or may not work depending
> on configuration. So the best two possible (but conflicting) answers I
> have are
>
> a) There are known users on gcc-4.1, and we never break things that
>     work for users, so gcc-4.1 (or possibly 4.0 if a user shows up) would
>     be the minimum version.
> b) gcc-4.1 and 4.2 have too many problems, so users are better off
>     when we tell them to upgrade to something newer, and a minimum
>     version of gcc-4.3 has fewer surprises. We should remove all
>     workarounds for pre-gcc-4.3 compilers and just force a build error
>     message.

If there's no real good reason (brokenness) to deprecate gcc-4.1, I would not
do it.I guess most people using old compilers know what they're doing.

My main motivation for keep on using gcc-4.1 is that it gives many warnings
that were disabled in later gcc versions.  I do look at all new warnings, and
send patches when they are real bugs, or are trivial to silence.

Lately the usefulness has been decreasing, as you've been too aggressively
killing compiler warnings with recent gcc versions (which became better) ;-)
Hence if I detected a new warning with a point or an rc release, it usually
means the code was never in nex (ugh)t, or the maintainer ignored your patch.

I could easily switch to v4.9 from kernel.org crosstool, though, but then I
would loose all those warnings.

BTW, below is the diff I use to avoid an ICE.
After that, it builds and (test)boots fine on ARAnyM ;-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index ec0848fcca02d896..eb75b324ac0ac53d 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -650,13 +650,16 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
                   struct gfs2_glock **glp)
 {
        struct super_block *s = sdp->sd_vfs;
-       struct lm_lockname name = { .ln_number = number,
+       // FIXME Avoid gcc 4.1.2 20061115 (prerelease) (Ubuntu 4.1.1-21) ICE
+       //struct lm_lockname name = { .ln_number = number,
+       struct lm_lockname name = {
                                    .ln_type = glops->go_type,
                                    .ln_sbd = sdp };
        struct gfs2_glock *gl, *tmp = NULL;
        struct address_space *mapping;
        struct kmem_cache *cachep;
        int ret, tries = 0;
+       name.ln_number = number;

        rcu_read_lock();
        gl = rhashtable_lookup_fast(&gl_hash_table, &name, ht_parms);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 86ccc01593937d93..8783b72df5fa3d0c 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1767,7 +1767,11 @@ static void try_rgrp_unlink(struct gfs2_rgrpd
*rgd, u64 *last_unlinked, u64 skip
        struct gfs2_inode *ip;
        int error;
        int found = 0;
-       struct gfs2_rbm rbm = { .rgd = rgd, .bii = 0, .offset = 0 };
+       // FIXME Avoid gcc 4.1.2 20061115 (prerelease) (Ubuntu 4.1.1-21) ICE
+       // struct gfs2_rbm rbm = { .rgd = rgd, .bii = 0, .offset = 0 };
+       struct gfs2_rbm rbm = { .bii = 0, .offset = 0 };
+       rbm.rgd = rgd;
+

        while (1) {
                down_write(&sdp->sd_log_flush_lock);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
