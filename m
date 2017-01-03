From: Brendan Gregg <brendan.d.gregg@gmail.com>
Subject: Re: [PATCH 11/13] fs: fix unsigned enum warning with gcc-4.2
Date: Tue, 3 Jan 2017 14:47:09 -0800
Message-ID: <CAE40pdenVkk-JerdB905nyupoDDPiQk9qv4p1Jv62kcj3-dKhQ@mail.gmail.com>
References: <20161216105634.235457-1-arnd@arndb.de> <20161216105634.235457-12-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20161216105634.235457-12-arnd@arndb.de>
Sender: linux-arch-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kernel-build-reports@lists.linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 16, 2016 at 2:56 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> With arm-linux-gcc-4.2, almost every file we build in the kernel ends
> up with this warning:
>
> include/linux/fs.h:2648: warning: comparison of unsigned expression < 0 is always false
>

Thanks, I'd like to see this fixed as a similar warning gets printed
whenever running many of the bcc/BPF tools, which gets annoying and is
user-visible. eg:

# /usr/share/bcc/tools/xfsslower 1
In file included from /virtual/main.c:3:
/lib/modules/4.8.6-300.fc25.x86_64/build/include/linux/fs.h:2677:9:
warning: comparison of unsigned enum expression < 0 is always false
[-Wtautological-compare]
        if (id < 0 || id >= READING_MAX_ID)
            ~~ ^ ~
1 warning generated.
Tracing XFS operations slower than 1 ms
TIME     COMM           PID    T BYTES   OFF_KB   LAT(ms) FILENAME
14:44:27 cksum          4414   R 65536   0           1.02 chcon
14:44:27 cksum          4414   R 65536   0           1.20 cpio
14:44:27 cksum          4414   R 65536   0           1.01 diff
14:44:27 cksum          4414   R 65536   0           1.15 dir
[...]

This patch fixes the warning.

Brendan

>
> Later versions don't have this problem, but it's easy enough to
> work around.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/linux/fs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 398cf20a706d..782c2a292fd7 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2645,7 +2645,7 @@ static const char * const kernel_read_file_str[] = {
>
>  static inline const char *kernel_read_file_id_str(enum kernel_read_file_id id)
>  {
> -       if (id < 0 || id >= READING_MAX_ID)
> +       if ((unsigned)id >= READING_MAX_ID)
>                 return kernel_read_file_str[READING_UNKNOWN];
>
>         return kernel_read_file_str[id];
> --
> 2.9.0
>
