From: Jan Bolke <jan.bolke@synopsys.com>
Subject: Unexpected Behavior of post-indexed LDR/STR to unmapped addresses
Date: Mon, 14 Jan 2019 10:30:58 +0000
Message-ID: <93B846538060DA46A9945E98A2E521E90141C32A@DE02WEMBXB.internal.synopsys.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9004379365939175640=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89FB74A3D3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jan 2019 05:31:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 30X2KyWOGUQp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Jan 2019 05:31:50 -0500 (EST)
Received: from smtprelay.synopsys.com (smtprelay.synopsys.com [198.182.47.9])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8734B4A3D1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jan 2019 05:31:50 -0500 (EST)
Received: from mailhost.synopsys.com (mailhost2.synopsys.com [10.13.184.66])
 by smtprelay.synopsys.com (Postfix) with ESMTP id 9272224E2179
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jan 2019 02:31:49 -0800 (PST)
Received: from US01WXQAHTC1.internal.synopsys.com
 (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
 by mailhost.synopsys.com (Postfix) with ESMTP id 6FD853B27
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Jan 2019 02:31:49 -0800 (PST)
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

--===============9004379365939175640==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_93B846538060DA46A9945E98A2E521E90141C32ADE02WEMBXBinter_"

--_000_93B846538060DA46A9945E98A2E521E90141C32ADE02WEMBXBinter_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi all,

Currently I am experimenting with KVM. I want to measure the cost of data a=
ccesses over the KVM_EXIT_MMIO mechanism.
I want to only map the executable code in a memory slot and let all variabl=
e access use the KVM_EXIT_MMIO mechanism.
I placed the .text section of my executable in a range of a mapped memory s=
lot, whereas the .data* and *.bss sections where linked to an unmapped addr=
ess range.
Then I observed some strange behavior:
When accessing unmapped address with str instructions they lead to an KVM_E=
XIT_MMIO as expected.
However, if the str instruction is post-indexed, KVM exits with KVM_EXIT_UN=
KNOWN.

Is this behavior expected?

Thanks in advance!

Best Regards
Jan
----------------------------------------------------------------

For convenience I built a minimal example to demonstrate my point (running =
on a raspi3 b+, consisting of start.s and minimal_kvm.c):
as start.s -o start.o
objcopy -S -O binary start.o start.img
gcc  minimal kvm.c -o minimal_kvm
./minimal_kvm
mmio_exit when accessing address 0x5000.
mmio_exit when accessing address 0x5008.
unknown exit.

start.s:
.global _start:
_start:
// move an unmapped addr to a gpr
mov x2, #0x5000
// first try direct mmio-exit
str xzr, [x2]
// then try pre-indexed str
str xzr, [x2, #8]
// then try the post-indexed str
str xzr, [x2], #8


minimal_kvm.c:
#include <err.h>
#include <fcntl.h>
#include <linux/kvm.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <asm/kvm.h>
#include <stddef.h>
#include <asm-generic/errno-base.h>

int main(void)
{
    int kvm, vmfd, vcpufd, ret;
    int fd;
    char *mem;
    size_t mmap_size;
    struct kvm_run *run;
    struct kvm_vcpu_init vcpu_init;
    struct stat sb;
    fd =3D open("./start.img", O_RDWR);
    fstat(fd, &sb);
    const char *memblock;

    memblock =3D mmap(NULL, sb.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
    if (memblock =3D=3D MAP_FAILED)
       err(1, "mem map failed");

    /* check if /dev/kvm is there with proper permissions */
    kvm =3D open("/dev/kvm", O_RDWR | O_CLOEXEC);
    if (kvm =3D=3D -1)
        err(1, "/dev/kvm");

    /* Make sure we have the stable version of the API */
    ret =3D ioctl(kvm, KVM_GET_API_VERSION, NULL);
    if (ret =3D=3D -1)
        err(1, "KVM_GET_API_VERSION");
    if (ret !=3D 12)
        errx(1, "KVM_GET_API_VERSION %d, expected 12", ret);

    /* create vm of type 0 (recommended by documentation) */
    vmfd =3D ioctl(kvm, KVM_CREATE_VM, (unsigned long)0);
    if (vmfd =3D=3D -1)
        err(1, "KVM_CREATE_VM");

    /* Allocate one aligned page of guest memory to hold the code. */
    mem =3D mmap(NULL, 0x1000, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANO=
NYMOUS, -1, 0);
    if (mem =3D=3D MAP_FAILED)
        err(1, "allocating guest memory");
    memcpy(mem, memblock, sb.st_size);

    struct kvm_userspace_memory_region region =3D {
        .slot =3D 0,
        .guest_phys_addr =3D 0x0000,
        .memory_size =3D 0x1000,
        .userspace_addr =3D (uint64_t)mem,
    };
    ret =3D ioctl(vmfd, KVM_SET_USER_MEMORY_REGION, &region);
    if (ret =3D=3D -1)
        err(1, "KVM_SET_USER_MEMORY_REGION");

    /* create virtual cpu with id 0 */
    vcpufd =3D ioctl(vmfd, KVM_CREATE_VCPU, (unsigned long)0);
    if (vcpufd =3D=3D -1)
        err(1, "KVM_CREATE_VCPU");

    /* get the preferred guest type to match underlying host */
    ret =3D ioctl(vmfd, KVM_ARM_PREFERRED_TARGET, &vcpu_init);
    if (ret =3D=3D -1){
      err(1, "KVM_ARM_PREFERRED_TARGET");
    }

    /* init vcpu with preferred guest type */
    ret =3D ioctl(vcpufd, KVM_ARM_VCPU_INIT, &vcpu_init);
    if (ret =3D=3D -1){
      err(1, "KVM_ARM_VCPU_INIT");
    }

    /* Map the shared kvm_run structure and following data. */
    ret =3D ioctl(kvm, KVM_GET_VCPU_MMAP_SIZE, NULL);
    if (ret =3D=3D -1)
        err(1, "KVM_GET_VCPU_MMAP_SIZE");
    mmap_size =3D ret;
    if (mmap_size < sizeof(*run))
        err(1, "KVM_GET_VCPU_MMAP_SIZE unexpectedly small");
    run =3D mmap(NULL, mmap_size, PROT_READ | PROT_WRITE, MAP_SHARED, vcpuf=
d, 0);
    if (!run)
        err(1, "mmap vcpu");

    // set pc
    struct kvm_one_reg reg;
    reg.id =3D KVM_REG_ARM64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs=
.pc) | KVM_REG_SIZE_U64;
    __u64 reg_value =3D 0;
    reg.addr =3D(__u64)(&reg_value);
    ret =3D ioctl(vcpufd, KVM_SET_ONE_REG, &reg);
    if (ret !=3D 0){
      err(1, "KVM_SET_ONE_REG");
    }

    do {
      ret =3D ioctl(vcpufd, KVM_RUN, NULL);
      if (run->exit_reason =3D=3D KVM_EXIT_MMIO) {
        __u64 guest_addr =3D run->mmio.phys_addr;
        printf("mmio_exit when accessing address %#x\n", guest_addr);
      }
      if (run->exit_reason =3D=3D KVM_EXIT_UNKNOWN) {
        __u64 pc =3D ioctl(vcpufd, KVM_GET_ONE_REG, &reg);
        printf("unknown exit.\n");
      }
    } while (run->exit_reason !=3D KVM_EXIT_UNKNOWN);

    munmap((void*)memblock, sb.st_size);
    return 0;
}





--_000_93B846538060DA46A9945E98A2E521E90141C32ADE02WEMBXBinter_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi all,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Currently I am experimenting with KVM. I want to mea=
sure the cost of data accesses over the KVM_EXIT_MMIO mechanism.
<o:p></o:p></p>
<p class=3D"MsoNormal">I want to only map the executable code in a memory s=
lot and let all variable access use the KVM_EXIT_MMIO mechanism.<o:p></o:p>=
</p>
<p class=3D"MsoNormal">I placed the .text section of my executable in a ran=
ge of a mapped memory slot, whereas the .data* and *.bss sections where lin=
ked to an unmapped address range.<o:p></o:p></p>
<p class=3D"MsoNormal">Then I observed some strange behavior:<o:p></o:p></p=
>
<p class=3D"MsoNormal">When accessing unmapped address with str instruction=
s they lead to an KVM_EXIT_MMIO as expected.<o:p></o:p></p>
<p class=3D"MsoNormal">However, if the str instruction is post-indexed, KVM=
 exits with KVM_EXIT_UNKNOWN.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Is this behavior expected?<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks in advance!<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Best Regards<o:p></o:p></p>
<p class=3D"MsoNormal">Jan<o:p></o:p></p>
<p class=3D"MsoNormal">----------------------------------------------------=
------------<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">For convenience I built a minimal example to demonst=
rate my point (running on a raspi3 b&#43;, consisting of start.s and minima=
l_kvm.c):<o:p></o:p></p>
<p class=3D"MsoNormal">as start.s -o start.o<o:p></o:p></p>
<p class=3D"MsoNormal">objcopy -S -O binary start.o start.img<o:p></o:p></p=
>
<p class=3D"MsoNormal">gcc &nbsp;minimal kvm.c -o minimal_kvm<o:p></o:p></p=
>
<p class=3D"MsoNormal">./minimal_kvm<o:p></o:p></p>
<p class=3D"MsoNormal">mmio_exit when accessing address 0x5000.<o:p></o:p><=
/p>
<p class=3D"MsoNormal">mmio_exit when accessing address 0x5008.<o:p></o:p><=
/p>
<p class=3D"MsoNormal">unknown exit.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">start.s:<o:p></o:p></p>
<p class=3D"MsoNormal">.global _start:<o:p></o:p></p>
<p class=3D"MsoNormal">_start:<o:p></o:p></p>
<p class=3D"MsoNormal">// move an unmapped addr to a gpr<o:p></o:p></p>
<p class=3D"MsoNormal">mov x2, #0x5000<o:p></o:p></p>
<p class=3D"MsoNormal">// first try direct mmio-exit<o:p></o:p></p>
<p class=3D"MsoNormal">str xzr, [x2] <o:p></o:p></p>
<p class=3D"MsoNormal">// then try pre-indexed str<o:p></o:p></p>
<p class=3D"MsoNormal">str xzr, [x2, #8]<o:p></o:p></p>
<p class=3D"MsoNormal">// then try the post-indexed str<o:p></o:p></p>
<p class=3D"MsoNormal">str xzr, [x2], #8<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">minimal_kvm.c:<span style=3D"font-size:12.0pt;color:=
black"><br>
#include &lt;err.h&gt;<br>
#include &lt;fcntl.h&gt;<br>
#include &lt;linux/kvm.h&gt;<br>
#include &lt;stdint.h&gt;<br>
#include &lt;stdio.h&gt;<br>
#include &lt;stdlib.h&gt;<br>
#include &lt;string.h&gt;<br>
#include &lt;sys/ioctl.h&gt;<br>
#include &lt;sys/mman.h&gt;<br>
#include &lt;sys/stat.h&gt;<br>
#include &lt;sys/types.h&gt;<br>
#include &lt;sys/stat.h&gt;<br>
#include &lt;asm/kvm.h&gt;<br>
#include &lt;stddef.h&gt;<br>
#include &lt;asm-generic/errno-base.h&gt;<br>
<br>
int main(void)<br>
{<br>
&nbsp;&nbsp;&nbsp; int kvm, vmfd, vcpufd, ret;<br>
&nbsp;&nbsp;&nbsp; int fd;<br>
&nbsp;&nbsp;&nbsp; char *mem;<br>
&nbsp;&nbsp;&nbsp; size_t mmap_size;<br>
&nbsp;&nbsp;&nbsp; struct kvm_run *run;<br>
&nbsp;&nbsp;&nbsp; struct kvm_vcpu_init vcpu_init;<br>
&nbsp;&nbsp;&nbsp; struct stat sb;<br>
&nbsp;&nbsp;&nbsp; fd =3D open(&quot;./start.img&quot;, O_RDWR);<br>
&nbsp;&nbsp;&nbsp; fstat(fd, &amp;sb);<br>
&nbsp;&nbsp;&nbsp; const char *memblock;<br>
<br>
&nbsp;&nbsp;&nbsp; memblock =3D mmap(NULL, sb.st_size, PROT_READ, MAP_PRIVA=
TE, fd, 0);<br>
&nbsp;&nbsp;&nbsp; if (memblock =3D=3D MAP_FAILED)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; err(1, &quot;mem map failed&quot;);<br=
>
<br>
&nbsp;&nbsp;&nbsp; /* check if /dev/kvm is there with proper permissions */=
<br>
&nbsp;&nbsp;&nbsp; kvm =3D open(&quot;/dev/kvm&quot;, O_RDWR | O_CLOEXEC);<=
br>
&nbsp;&nbsp;&nbsp; if (kvm =3D=3D -1)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; err(1, &quot;/dev/kvm&quot;);<br=
>
<br>
&nbsp;&nbsp;&nbsp; /* Make sure we have the stable version of the API */<br=
>
&nbsp;&nbsp;&nbsp; ret =3D ioctl(kvm, KVM_GET_API_VERSION, NULL);<br>
&nbsp;&nbsp;&nbsp; if (ret =3D=3D -1)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; err(1, &quot;KVM_GET_API_VERSION=
&quot;);<br>
&nbsp;&nbsp;&nbsp; if (ret !=3D 12)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; errx(1, &quot;KVM_GET_API_VERSIO=
N %d, expected 12&quot;, ret);<br>
<br>
&nbsp;&nbsp;&nbsp; /* create vm of type 0 (recommended by documentation) */=
<br>
&nbsp;&nbsp;&nbsp; vmfd =3D ioctl(kvm, KVM_CREATE_VM, (unsigned long)0);<br=
>
&nbsp;&nbsp;&nbsp; if (vmfd =3D=3D -1)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; err(1, &quot;KVM_CREATE_VM&quot;=
);<br>
<br>
&nbsp;&nbsp;&nbsp; /* Allocate one aligned page of guest memory to hold the=
 code. */<br>
&nbsp;&nbsp;&nbsp; mem =3D mmap(NULL, 0x1000, PROT_READ | PROT_WRITE, MAP_S=
HARED | MAP_ANONYMOUS, -1, 0);<br>
&nbsp;&nbsp;&nbsp; if (mem =3D=3D MAP_FAILED)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; err(1, &quot;allocating guest me=
mory&quot;);<br>
&nbsp;&nbsp;&nbsp; memcpy(mem, memblock, sb.st_size);<br>
<br>
&nbsp;&nbsp;&nbsp; struct kvm_userspace_memory_region region =3D {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .slot =3D 0,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .guest_phys_addr =3D 0x0000,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .memory_size =3D 0x1000,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .userspace_addr =3D (uint64_t)me=
m,<br>
&nbsp;&nbsp;&nbsp; };<br>
&nbsp;&nbsp;&nbsp; ret =3D ioctl(vmfd, KVM_SET_USER_MEMORY_REGION, &amp;reg=
ion);<br>
&nbsp;&nbsp;&nbsp; if (ret =3D=3D -1)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; err(1, &quot;KVM_SET_USER_MEMORY=
_REGION&quot;);<br>
<br>
&nbsp;&nbsp;&nbsp; /* create virtual cpu with id 0 */<br>
&nbsp;&nbsp;&nbsp; vcpufd =3D ioctl(vmfd, KVM_CREATE_VCPU, (unsigned long)0=
);<br>
&nbsp;&nbsp;&nbsp; if (vcpufd =3D=3D -1)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; err(1, &quot;KVM_CREATE_VCPU&quo=
t;);<br>
<br>
&nbsp;&nbsp;&nbsp; /* get the preferred guest type to match underlying host=
 */<br>
&nbsp;&nbsp;&nbsp; ret =3D ioctl(vmfd, KVM_ARM_PREFERRED_TARGET, &amp;vcpu_=
init);<br>
&nbsp;&nbsp;&nbsp; if (ret =3D=3D -1){<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; err(1, &quot;KVM_ARM_PREFERRED_TARGET&quot;)=
;<br>
&nbsp;&nbsp;&nbsp; }<br>
<br>
&nbsp;&nbsp;&nbsp; /* init vcpu with preferred guest type */<br>
&nbsp;&nbsp;&nbsp; ret =3D ioctl(vcpufd, KVM_ARM_VCPU_INIT, &amp;vcpu_init)=
;<br>
&nbsp;&nbsp;&nbsp; if (ret =3D=3D -1){<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; err(1, &quot;KVM_ARM_VCPU_INIT&quot;);<br>
&nbsp;&nbsp;&nbsp; }<br>
<br>
&nbsp;&nbsp;&nbsp; /* Map the shared kvm_run structure and following data. =
*/<br>
&nbsp;&nbsp;&nbsp; ret =3D ioctl(kvm, KVM_GET_VCPU_MMAP_SIZE, NULL);<br>
&nbsp;&nbsp;&nbsp; if (ret =3D=3D -1)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; err(1, &quot;KVM_GET_VCPU_MMAP_S=
IZE&quot;);<br>
&nbsp;&nbsp;&nbsp; mmap_size =3D ret;<br>
&nbsp;&nbsp;&nbsp; if (mmap_size &lt; sizeof(*run))<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; err(1, &quot;KVM_GET_VCPU_MMAP_S=
IZE unexpectedly small&quot;);<br>
&nbsp;&nbsp;&nbsp; run =3D mmap(NULL, mmap_size, PROT_READ | PROT_WRITE, MA=
P_SHARED, vcpufd, 0);<br>
&nbsp;&nbsp;&nbsp; if (!run)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; err(1, &quot;mmap vcpu&quot;);<b=
r>
<br>
&nbsp;&nbsp;&nbsp; // set pc<br>
&nbsp;&nbsp;&nbsp; struct kvm_one_reg reg;<br>
&nbsp;&nbsp;&nbsp; reg.id =3D KVM_REG_ARM64 | KVM_REG_ARM_CORE | KVM_REG_AR=
M_CORE_REG(regs.pc) | KVM_REG_SIZE_U64;<br>
&nbsp;&nbsp;&nbsp; __u64 reg_value =3D 0;<br>
&nbsp;&nbsp;&nbsp; reg.addr =3D(__u64)(&amp;reg_value);<br>
&nbsp;&nbsp;&nbsp; ret =3D ioctl(vcpufd, KVM_SET_ONE_REG, &amp;reg);<br>
&nbsp;&nbsp;&nbsp; if (ret !=3D 0){<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; err(1, &quot;KVM_SET_ONE_REG&quot;);<br>
&nbsp;&nbsp;&nbsp; }<br>
<br>
&nbsp;&nbsp;&nbsp; do {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ret =3D ioctl(vcpufd, KVM_RUN, NULL);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (run-&gt;exit_reason =3D=3D KVM_EXIT_MMIO=
) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; __u64 guest_addr =3D run-&gt;mmi=
o.phys_addr;<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;mmio_exit when acce=
ssing address %#x\n&quot;, guest_addr);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (run-&gt;exit_reason =3D=3D KVM_EXIT_UNKN=
OWN) {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; __u64 pc =3D ioctl(vcpufd, KVM_G=
ET_ONE_REG, &amp;reg);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; printf(&quot;unknown exit.\n&quo=
t;);<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>
&nbsp;&nbsp;&nbsp; } while (run-&gt;exit_reason !=3D KVM_EXIT_UNKNOWN);<br>
<br>
&nbsp;&nbsp;&nbsp; munmap((void*)memblock, sb.st_size);<br>
&nbsp;&nbsp;&nbsp; return 0;<br>
}</span><o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_93B846538060DA46A9945E98A2E521E90141C32ADE02WEMBXBinter_--

--===============9004379365939175640==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============9004379365939175640==--
