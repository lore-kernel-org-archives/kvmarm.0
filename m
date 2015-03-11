From: Greg Bellows <greg.bellows@linaro.org>
Subject: Re: [PATCH v2 1/6] target-arm: kvm: save/restore mp
	state
Date: Wed, 11 Mar 2015 08:42:02 -0500
Message-ID: <CAOgzsHU4JXZbbQ=Bf3eY0YnjOQxMATLMnyR1jD=4eUzUExMqQA@mail.gmail.com>
References: <1425479753-18349-1-git-send-email-alex.bennee@linaro.org>
	<1425479753-18349-2-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=001a11c11d12a04cca0511036eee
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1425479753-18349-2-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org, marc.zyngier@arm.com, QEMU Developers <qemu-devel@nongnu.org>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

--001a11c11d12a04cca0511036eee
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 4, 2015 at 8:35 AM, Alex Benn=C3=A9e <alex.bennee@linaro.org> w=
rote:

> This adds the saving and restore of the current Multi-Processing state
> of the machine. While the KVM_GET/SET_MP_STATE API exposes a number of
> potential states for x86 we only use two for ARM. Either the process is
> running or not. We then save this state into the cpu_powered TCG state
> to avoid changing the serialisation format.
>
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> ---
> v2
>   - make mpstate field runtime dependant (kvm_enabled())
>   - drop initial KVM_CAP_MP_STATE requirement
>   - re-use cpu_powered instead of new field
>
> diff --git a/target-arm/machine.c b/target-arm/machine.c
> index 9446e5a..185f9a2 100644
> --- a/target-arm/machine.c
> +++ b/target-arm/machine.c
> @@ -161,6 +161,7 @@ static const VMStateInfo vmstate_cpsr =3D {
>      .put =3D put_cpsr,
>  };
>
> +
>

remove =E2=80=8Bextraneous space
=E2=80=8B


>  static void cpu_pre_save(void *opaque)
>  {
>      ARMCPU *cpu =3D opaque;
> @@ -170,6 +171,20 @@ static void cpu_pre_save(void *opaque)
>              /* This should never fail */
>              abort();
>          }
> +#if defined CONFIG_KVM
>

=E2=80=8BThe convention for ifdefing KVMatures appears to be more around th=
e
feature rather than KVM_CONFIG.  For instance =E2=80=8Bloo fek at
kvm_check_extension in kvm-all.c.  I may be missing something but if you
follow this convention this should be

    #ifdef KVM_CAP_MP_STATE



> +        if (kvm_check_extension(CPU(cpu)->kvm_state, KVM_CAP_MP_STATE)) =
{
> +            struct kvm_mp_state mp_state;
> +            int ret =3D kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MP_STATE,
> &mp_state);
> +            if (ret) {
> +                fprintf(stderr, "%s: failed to get MP_STATE %d/%s\n",
> +                        __func__, ret, strerror(ret));
> +                abort();
> +            }
> +            cpu->powered_off =3D
> +                (mp_state.mp_state =3D=3D KVM_MP_STATE_RUNNABLE)
> +                ? false : true;
> +        }
> +#endif
>      } else {
>          if (!write_cpustate_to_list(cpu)) {
>              /* This should never fail. */
> @@ -222,6 +237,20 @@ static int cpu_post_load(void *opaque, int version_i=
d)
>           * we're using it.
>           */
>          write_list_to_cpustate(cpu);
> +#if defined CONFIG_KVM
> +        if (kvm_check_extension(CPU(cpu)->kvm_state, KVM_CAP_MP_STATE)) =
{
> +            struct kvm_mp_state mp_state =3D {
> +                .mp_state =3D
> +                cpu->powered_off ? KVM_MP_STATE_HALTED :
> KVM_MP_STATE_RUNNABLE
> +            };
> +            int ret =3D kvm_vcpu_ioctl(CPU(cpu), KVM_SET_MP_STATE,
> &mp_state);
> +            if (ret) {
> +                fprintf(stderr, "%s: failed to set MP_STATE %d/%s\n",
> +                        __func__, ret, strerror(ret));
> +                return -1;
> +            }
> +        }
> +#endif
>      } else {
>          if (!write_list_to_cpustate(cpu)) {
>              return -1;
> --
> 2.3.1
>
>
> =E2=80=8BBesides these the above nits...

Reviewed-by: Greg Bellows <greg.bellows@linaro.org>=E2=80=8B

--001a11c11d12a04cca0511036eee
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Wed, Mar 4, 2015 at 8:35 AM, Alex Benn=C3=A9e <span dir=3D"=
ltr">&lt;<a href=3D"mailto:alex.bennee@linaro.org" target=3D"_blank">alex.b=
ennee@linaro.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote"=
 style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Th=
is adds the saving and restore of the current Multi-Processing state<br>
of the machine. While the KVM_GET/SET_MP_STATE API exposes a number of<br>
potential states for x86 we only use two for ARM. Either the process is<br>
running or not. We then save this state into the cpu_powered TCG state<br>
to avoid changing the serialisation format.<br>
<br>
Signed-off-by: Alex Benn=C3=A9e &lt;<a href=3D"mailto:alex.bennee@linaro.or=
g">alex.bennee@linaro.org</a>&gt;<br>
<br>
---<br>
v2<br>
=C2=A0 - make mpstate field runtime dependant (kvm_enabled())<br>
=C2=A0 - drop initial KVM_CAP_MP_STATE requirement<br>
=C2=A0 - re-use cpu_powered instead of new field<br>
<br>
diff --git a/target-arm/machine.c b/target-arm/machine.c<br>
index 9446e5a..185f9a2 100644<br>
--- a/target-arm/machine.c<br>
+++ b/target-arm/machine.c<br>
@@ -161,6 +161,7 @@ static const VMStateInfo vmstate_cpsr =3D {<br>
=C2=A0 =C2=A0 =C2=A0.put =3D put_cpsr,<br>
=C2=A0};<br>
<br>
+<br></blockquote><div><div class=3D"gmail_default" style=3D"font-family:ar=
ial,helvetica,sans-serif;display:inline"><br></div></div><div><div class=3D=
"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;display:inl=
ine">remove =E2=80=8Bextraneous space</div></div><div><div class=3D"gmail_d=
efault" style=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=
=80=8B</div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0=
 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
=C2=A0static void cpu_pre_save(void *opaque)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0ARMCPU *cpu =3D opaque;<br>
@@ -170,6 +171,20 @@ static void cpu_pre_save(void *opaque)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* This should never fail *=
/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0abort();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+#if defined CONFIG_KVM<br></blockquote><div><br></div><div><div class=3D"g=
mail_default" style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BThe=
 convention for ifdefing KVMatures appears to be more around the feature ra=
ther than KVM_CONFIG.=C2=A0 For instance =E2=80=8Bloo=C2=A0fek at kvm_check=
_extension in kvm-all.c.=C2=A0 I may be missing something but if you follow=
 this convention this should be=C2=A0</div><div class=3D"gmail_default" sty=
le=3D"font-family:arial,helvetica,sans-serif"><br></div><div class=3D"gmail=
_default" style=3D"font-family:arial,helvetica,sans-serif">=C2=A0 =C2=A0 #i=
fdef KVM_CAP_MP_STATE</div><br></div><div>=C2=A0</div><blockquote class=3D"=
gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-=
left:1ex">
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (kvm_check_extension(CPU(cpu)-&gt;kvm_state=
, KVM_CAP_MP_STATE)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct kvm_mp_state mp_state;<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int ret =3D kvm_vcpu_ioctl(CPU(c=
pu), KVM_GET_MP_STATE, &amp;mp_state);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, &q=
uot;%s: failed to get MP_STATE %d/%s\n&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 __func__, ret, strerror(ret));<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 abort();<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu-&gt;powered_off =3D<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (mp_state.mp_state=
 =3D=3D KVM_MP_STATE_RUNNABLE)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ? false : true;<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+#endif<br>
=C2=A0 =C2=A0 =C2=A0} else {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!write_cpustate_to_list(cpu)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* This should never fail. =
*/<br>
@@ -222,6 +237,20 @@ static int cpu_post_load(void *opaque, int version_id)=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * we&#39;re using it.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0write_list_to_cpustate(cpu);<br>
+#if defined CONFIG_KVM<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (kvm_check_extension(CPU(cpu)-&gt;kvm_state=
, KVM_CAP_MP_STATE)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct kvm_mp_state mp_state =3D=
 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .mp_state =3D<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cpu-&gt;powered_of=
f ? KVM_MP_STATE_HALTED : KVM_MP_STATE_RUNNABLE<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 };<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int ret =3D kvm_vcpu_ioctl(CPU(c=
pu), KVM_SET_MP_STATE, &amp;mp_state);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, &q=
uot;%s: failed to set MP_STATE %d/%s\n&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 __func__, ret, strerror(ret));<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+#endif<br>
=C2=A0 =C2=A0 =C2=A0} else {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!write_list_to_cpustate(cpu)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -1;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.3.1<br>
<br>
<br></font></span></blockquote><div><div class=3D"gmail_default" style=3D"f=
ont-family:arial,helvetica,sans-serif">=E2=80=8BBesides these the above nit=
s...</div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica=
,sans-serif"><br></div><div class=3D"gmail_default" style=3D"font-family:ar=
ial,helvetica,sans-serif">Reviewed-by: Greg Bellows &lt;<a href=3D"mailto:g=
reg.bellows@linaro.org">greg.bellows@linaro.org</a>&gt;=E2=80=8B</div><br><=
/div><div>=C2=A0</div></div><br></div></div>

--001a11c11d12a04cca0511036eee--
