From: liang yan <liangy@hpe.com>
Subject: Re: Could not boot a guest vm from kvm mode based on
 APM X-Gene Host and latest qemu
Date: Wed, 16 Sep 2015 18:02:40 -0600
Message-ID: <55FA0320.1040701@hpe.com>
References: <55F76064.8010504@hpe.com> <87y4g6mo0l.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <87y4g6mo0l.fsf@linaro.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu



On 09/16/2015 08:34 AM, Alex Benn=C3=A9e wrote:
> liang yan <liangy@hpe.com> writes:
>
>> Hello, All,
>>
>> I am trying to enable kvm for a guest vm on an APM X-Gene Host with
>> latest qemu, but could not make it work.
>>
>> The host is APM X-Gene 8-core, Linux kernel is 4.1.0-rc7-1-arm64,
>>
>> Guest kernel is linux-3.16rc3
>>
>> QEMU is latest version
>>
>> Host has these dmesg info
>> [    2.708259] kvm [1]: GICH base=3D0x780c0000, GICV base=3D0x780e0000=
, IRQ=3D25
>> [    2.708327] kvm [1]: timer IRQ30
>> [    2.708335] kvm [1]: Hyp mode initialized successfully
>>
>> Host has dev/kvm.
>>
>> command-line is
>> aarch64-softmmu/qemu-system-aarch64 -machine virt,kernel_irqchip=3Doff
>> -cpu cortex-a57 -machine accel=3Dkvm -nographic -smp 1 -m 2048 -kernel
>> aarch64-linux-3.16rc3-buildroot.img  --append "console=3DttyAMA0"
> I thought I recognised one of my images ;-)
>
> Why are you running with kernel_irqchip=3Doff?


Hello, Alex,

Thanks for your reply and your pre-boot image. Very helpful.

The reason I ran with "kernel_irqchip=3Doff" is because it showed the=20
error "Create kernel irqchip failed: No such device"
are you familiar with it?

I did not try kernel 4.3.x yet, have you released on your linaro website=20
now?

Thanks for your log file, it shows something wrong with the vcpu, I am=20
gonna check the kvm code from host kernel now.
Will let you know the update.


Best,
Liang

> Without it I can boot the image fine on my APM running 4.3.0-rc1-ajb bu=
t
> with it I helpfully seg the kernel:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> [16035.990518] Bad mode in Synchronous Abort handler detected, code 0x8=
6000006 -- IABT (current EL)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [16035.997970] CPU: 1 PID: 21328 Comm: qemu-system-aar Not tainted 4.3.=
0-rc1-ajb #446
> [16036.004203] Hardware name: APM X-Gene Mustang board (DT)
> [16036.008191] task: ffffffc3ecea8000 ti: ffffffc3d8078000 task.ti: fff=
fffc3d8078000
> [16036.014338] PC is at 0x0
> [16036.015564] LR is at kvm_vgic_map_resources+0x30/0x3c
> [16036.019291] pc : [<0000000000000000>] lr : [<ffffffc0000ae900>] psta=
te: 00000145
> [16036.025350] sp : ffffffc3d807bb20
> [16036.027348] x29: ffffffc3d807bb20 x28: ffffffc3d8078000
> [16036.031355] x27: ffffffc000642000 x26: 000000000000001d
> [16036.035361] x25: 000000000000011b x24: ffffffc3d80c1000
> [16036.039368] x23: 0000000000000000 x22: 0000000000000000
> [16036.043374] x21: ffffffc0fa240000 x20: ffffffc0fa807800
> [16036.047380] x19: ffffffc0fa807800 x18: 0000007f97af20e0
> [16036.051387] x17: 0000007f99c44810 x16: ffffffc0001fb030
> [16036.055394] x15: 0000007f99cc9588 x14: 0000000000922000
> [16036.059401] x13: 000000000097eb80 x12: 00000000004de0f0
> [16036.063406] x11: 0000000000000038 x10: 00000000ffffffff
> [16036.067413] x9 : 0000007f97af2480 x8 : 0000000000000050
> [16036.071419] x7 : ffffffc3ec24c840 x6 : 0000000000000000
> [16036.075424] x5 : 0000000000000003 x4 : ffffffc3ece72080
> [16036.079430] x3 : ffffffc3ece72080 x2 : 0000000000000000
> [16036.083436] x1 : ffffffc000a26260 x0 : ffffffc0fa807800
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [16036.087628] Internal error: Oops - bad mode: 0 [#1] SMP
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

> [16036.091528] Modules linked in:
> [16036.093278] CPU: 1 PID: 21328 Comm: qemu-system-aar Not tainted 4.3.=
0-rc1-ajb #446
> [16036.099510] Hardware name: APM X-Gene Mustang board (DT)
> [16036.103497] task: ffffffc3ecea8000 ti: ffffffc3d8078000 task.ti: fff=
fffc3d8078000
> [16036.109642] PC is at 0x0
> [16036.110864] LR is at kvm_vgic_map_resources+0x30/0x3c
> [16036.114590] pc : [<0000000000000000>] lr : [<ffffffc0000ae900>] psta=
te: 00000145
> [16036.120649] sp : ffffffc3d807bb20
> [16036.122648] x29: ffffffc3d807bb20 x28: ffffffc3d8078000
> [16036.126654] x27: ffffffc000642000 x26: 000000000000001d
> [16036.130659] x25: 000000000000011b x24: ffffffc3d80c1000
> [16036.134666] x23: 0000000000000000 x22: 0000000000000000
> [16036.138671] x21: ffffffc0fa240000 x20: ffffffc0fa807800
> [16036.142678] x19: ffffffc0fa807800 x18: 0000007f97af20e0
> [16036.146685] x17: 0000007f99c44810 x16: ffffffc0001fb030
> [16036.150690] x15: 0000007f99cc9588 x14: 0000000000922000
> [16036.154696] x13: 000000000097eb80 x12: 00000000004de0f0
> [16036.158701] x11: 0000000000000038 x10: 00000000ffffffff
> [16036.162706] x9 : 0000007f97af2480 x8 : 0000000000000050
> [16036.166712] x7 : ffffffc3ec24c840 x6 : 0000000000000000
> [16036.170719] x5 : 0000000000000003 x4 : ffffffc3ece72080
> [16036.174725] x3 : ffffffc3ece72080 x2 : 0000000000000000
> [16036.178731] x1 : ffffffc000a26260 x0 : ffffffc0fa807800
>
>>
>> when using cpu "cortex-a57", got the error "kvm_init_vcpu failed:
>> Invalid argument"
>> when using cpu "host", got the error "Failed to retrieve host CPU feat=
ures!"
>>
>> By the way, all the command line works well under "tcg" mode.
>> Anyone has a quick idea? Thanks in advance.
>>
>> Best,
>> Liang
