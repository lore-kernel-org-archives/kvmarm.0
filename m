From: gengdongjiu <gengdj.1984@gmail.com>
Subject: Re: [PATCH v8 7/7] arm64: kvm: handle SError Interrupt by categorization
Date: Sat, 16 Dec 2017 12:47:46 +0800
Message-ID: <CAMj-D2CwHWNpXzeNMEVKGTveAwuJvja219NF6PZ7xqYMUY17Kw@mail.gmail.com>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
 <1510343650-23659-8-git-send-email-gengdongjiu@huawei.com> <5A0B1334.7060500@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <5A0B1334.7060500@arm.com>
Sender: linux-acpi-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: Dongjiu Geng <gengdongjiu@huawei.com>, wuquanming <wuquanming@huawei.com>, linux-doc@vger.kernel.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux@armlinux.org.uk, linuxarm@huawei.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Huangshaoyu <huangshaoyu@huawei.com>, kvmarm@lists.cs.columbia.edu, devel@acpica.org
List-Id: kvmarm@lists.cs.columbia.edu

[...]
>
>> +     case ESR_ELx_AET_UER:   /* The error has not been propagated */
>> +             /*
>> +              * Userspace only handle the guest SError Interrupt(SEI) i=
f the
>> +              * error has not been propagated
>> +              */
>> +             run->exit_reason =3D KVM_EXIT_EXCEPTION;
>> +             run->ex.exception =3D ESR_ELx_EC_SERROR;
>> +             run->ex.error_code =3D KVM_SEI_SEV_RECOVERABLE;
>> +             return 0;
>
> We should not pass RAS notifications to user space. The kernel either han=
dles
> them, or it panics(). User space shouldn't even know if the kernel suppor=
ts RAS

For the  ESR_ELx_AET_UER(Recoverable error), let us see its definition
below, which get from [0]

The state of the PE is Recoverable if all of the following are true:
=E2=80=94 The error has not been silently propagated.
=E2=80=94 The error has not been architecturally consumed by the PE. (The P=
E
architectural state is not infected.)
=E2=80=94 The exception is precise and PE can recover execution from the
preferred return address of the exception, if software locates and
repairs the error.
The PE cannot make correct progress without either consuming the error
or otherwise making the error unrecoverable. The error remains latent
in the system.
If software cannot locate and repair the error, either the application
or the VM, or both, must be isolated by software.

so we can see the  exception is precise and PE can recover execution
from the preferred return address of the exception, so let guest
handling it is
better, for example, if it is guest application RAS error, we can kill
the guest application instead of panic whole OS; if it is guest kernel
RAS error, guest will panic.
Host does not know which application of guest has error, so host can
not handle it, panic OS is not a good choice for the Recoverable
error.

[0]
https://static.docs.arm.com/ddi0587/a/RAS%20Extension-release%20candidate_m=
arch_29.pdf


> until it gets an MCEERR signal.

user space will detect whether kernel support RAS before handing it.

>
> You're making your firmware-first notification an EL3->EL0 signal, bypass=
ing the OS.
>
> If we get a RAS SError and there are no CPER records or values in the ERR=
 nodes,
> we should panic as it looks like the CPU/firmware is broken. (spurious RA=
S errors)


>
>
>> +     default:
>> +             /*
>> +              * Until now, the CPU supports RAS and SEI is fatal, or ho=
st
>> +              * does not support to handle the SError.
>> +              */
>> +             panic("This Asynchronous SError interrupt is dangerous, pa=
nic");
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>>  /*
>>   * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason)=
 on
>>   * proper exit to userspace.
>
>
>
> James
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
