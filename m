From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/5] configure: arm/arm64: Add --vmm
 option with no effect
Date: Sat, 2 Feb 2019 16:51:00 +0100
Message-ID: <20190202155100.gk4rnpgpdlbjpoh2@kamzik.brq.redhat.com>
References: <20190201111641.8299-1-alexandru.elisei@arm.com>
 <20190201111641.8299-3-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 497A94A3AD
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Feb 2019 10:51:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FD7FmN6W4ABj for <kvmarm@lists.cs.columbia.edu>;
 Sat,  2 Feb 2019 10:51:34 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8659C4A320
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Feb 2019 10:51:34 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190201111641.8299-3-alexandru.elisei@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 01, 2019 at 11:16:38AM +0000, Alexandru Elisei wrote:
> Add configuration option --vmm to specify the virtual machine manager.
> Valid choices are 'qemu' and 'kvmtool', the default being 'qemu'. This
> option is only available for the arm and arm64 architectures and does
> nothing for now.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  configure | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/configure b/configure
> index 44708b026422..0786e1604dba 100755
> --- a/configure
> +++ b/configure
> @@ -16,6 +16,7 @@ endian=""
>  pretty_print_stacks=yes
>  environ_default=yes
>  u32_long=
> +vmm="qemu"
>  
>  usage() {
>      cat <<-EOF
> @@ -24,6 +25,8 @@ usage() {
>  	Options include:
>  	    --arch=ARCH            architecture to compile for ($arch)
>  	    --processor=PROCESSOR  processor to compile for ($arch)
> +	    --vmm=VMM              virtual machine monitor to compile for (qemu
> +	                           or kvmtool, default is qemu) (arm/arm64 only)
>  	    --cross-prefix=PREFIX  cross compiler prefix
>  	    --cc=CC		   c compiler to use ($cc)
>  	    --cxx=CXX		   c++ compiler to use ($cxx)
> @@ -56,6 +59,9 @@ while [[ "$1" = -* ]]; do
>          --processor)
>  	    processor="$arg"
>  	    ;;
> +	--vmm)
> +	    vmm="$arg"
> +	    ;;
>  	--cross-prefix)
>  	    cross_prefix="$arg"
>  	    ;;
> @@ -108,6 +114,10 @@ if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
>      testdir=x86
>  elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
>      testdir=arm
> +    if [ "$vmm" != "qemu" ] && [ "$vmm" != "kvmtool" ]; then
> +        echo '--vmm must be one of "qemu" or "kvmtool"!'

nit: I'd drop the '!'

> +        usage
> +    fi
>  elif [ "$arch" = "ppc64" ]; then
>      testdir=powerpc
>      firmware="$testdir/boot_rom.bin"
> -- 
> 2.17.0
>
 
Reviewed-by: Andrew Jones <drjones@redhat.com>
